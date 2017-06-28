require 'rails_helper'

describe Assignment do
  it 'include Her::Model' do
    expect(Assignment.include?(Her::Model)).to be_truthy
  end
  
  it 'parse_root_in_json true' do
    expect(Assignment.parse_root_in_json?).to be_truthy
  end
  
  it 'have collection path customers/accounts/:account_id/service_requests/:service_request_id/assignments' do
    expect(Assignment.collection_path).to eq('customers/accounts/:account_id/service_requests/:service_request_id/assignments')
  end
  
  it { expect(Assignment.belongs_to(:service_request)).to be_truthy }
  it { expect(Assignment.has_many(:customer_ratings)).to be_truthy }
  
  describe 'attributes' do
    let(:assignment) {Assignment.new}
    it 'include attributes' do
      expect(assignment).to have_attributes(
        account_id: anything,
        service_request_id: anything,
        id: anything,
        status: anything,
        reason: anything,
      )
    end
  end
  
  it { expect(Assignment.constants.include? :CUSTOMER_DECLINE_REASONS).to be_truthy}
  
  describe '#diagnostic_fee' do
    let(:assignment) { Assignment.new(diagnostic_fee_cents: 100)}
    it 'return money object' do
      expect(assignment.diagnostic_fee.is_a?(Money)).to be_truthy
    end
  end
  
  describe '#responded?' do
    let(:assignment) { Assignment.new }
    context 'if status is responded' do
      it 'return true' do
        assignment.status = 'responded'
        expect(assignment.responded?).to be_truthy
      end
    end
    context 'if status is not responded' do
      it 'return false' do
        expect(assignment.responded?).to be_falsy
      end
    end
  end
  
  describe '#customer_accepted?' do
    let(:assignment) { Assignment.new }
    context 'if status is customer_accepted' do
      it 'return true' do
        assignment.status = 'customer_accepted'
        expect(assignment.customer_accepted?).to be_truthy
      end
    end
    context 'if status is not customer_accepted' do
      it 'return false' do
        expect(assignment.customer_accepted?).to be_falsy
      end
    end
  end
  
  describe '#customer_declined?' do
    let(:assignment) { Assignment.new }
    context 'if status is customer_declined' do
      it 'return true' do
        assignment.status = 'customer_declined'
        expect(assignment.customer_declined?).to be_truthy
      end
    end
    context 'if status is not customer_declined' do
      it 'return false' do
        expect(assignment.customer_declined?).to be_falsy
      end
    end
  end
  
  describe '#customer_accepting?' do
    let(:assignment) { Assignment.new }
    context 'if status is customer_accepting' do
      it 'return true' do
        assignment.status = 'customer_accepting'
        expect(assignment.customer_accepting?).to be_truthy
      end
    end
    context 'if status is not customer_accepted' do
      it 'return false' do
        expect(assignment.customer_accepting?).to be_falsy
      end
    end
  end
  
  describe '#waiting?' do
    let(:assignment) { Assignment.new }
    context 'if status is waiting' do
      it 'return true' do
        assignment.status = 'waiting'
        expect(assignment.waiting?).to be_truthy
      end
    end
    context 'if status is not waiting' do
      it 'return false' do
        expect(assignment.waiting?).to be_falsy
      end
    end
  end
  
  describe '#charging?' do
    let(:assignment) { Assignment.new(diagnostic_fee_cents: 1000, sagn_diagnostic_fee_cents: 10) }
    context 'sagn diagnostic fee is less than diagnostic fee' do
      it 'return true' do
        expect(assignment.charging?).to be_truthy
      end
    end
    context 'sagn diagnostic fee is greater than diagnostic fee' do
      it 'return false' do
        assignment.sagn_diagnostic_fee_cents= 1100
        expect(assignment.charging?).to be_falsy
      end
    end
  end
  
  describe '#start_accepting' do
    let(:assignment) { Assignment.new(id: 1, account_id: 1, service_request_id: 1)}
    context 'for valid data' do
      it 'return true' do
        stub_start_accepting_assignment(assignment.id, assignment.account_id, assignment.service_request_id, 200)
        expect(assignment.start_accepting).to be_nil
      end
    end
    context 'for invalid data' do
      it 'return false' do
        stub_start_accepting_assignment(assignment.id, assignment.account_id, assignment.service_request_id, 400)
        expect(assignment.start_accepting).to eq({})
      end
    end
  end
  
  describe '#accept(token)' do
    let(:assignment) { Assignment.new(id: 1, account_id: 1, service_request_id: 1)}
    context 'for valid data' do
      it 'return true' do
        stub_accept_assignment(assignment.id, assignment.account_id, assignment.service_request_id, 'validStripeToken', 200)
        expect(assignment.accept('validStripeToken')).to be_truthy
      end
    end
    context 'for invalid data' do
      it 'return false' do
        stub_accept_assignment(assignment.id, assignment.account_id, assignment.service_request_id, 'invalidStripeToken', 400)
        expect(assignment.accept('invalidStripeToken')).to eq({})
      end
    end
  end
  
  describe '#decline(reason, new_search)' do
    let(:assignment) { Assignment.new(id: 1, account_id: 1, service_request_id: 1)}
    context 'for valid data' do
      it 'return true' do
        stub_decline_assignment(assignment.id, assignment.account_id, assignment.service_request_id, 'reason', 200, 'Yes')
        expect(assignment.decline('reason', 'Yes')).to be_truthy
      end
    end
    context 'for invalid data' do
      it 'return false' do
        stub_decline_assignment(assignment.id, assignment.account_id, assignment.service_request_id, 'reason', 400, 'No')
        expect(assignment.decline('reason', 'No')).to eq({})
      end
    end
  end
  
  describe '#start_accepting_estimation' do
    let(:assignment) { Assignment.new(id: 1, account_id: 1, service_request_id: 1)}
    context 'for valid data' do
      it 'return true' do
        stub_start_accepting_estimation(assignment.id, assignment.account_id, assignment.service_request_id, 200)
        expect(assignment.start_accepting_estimation).to be_truthy
      end
    end
    context 'for invalid data' do
      it 'return false' do
        stub_start_accepting_estimation(assignment.id, assignment.account_id, assignment.service_request_id, 400)
        expect(assignment.start_accepting_estimation).to eq({})
      end
    end
  end
  
  describe '#accept_estimation(token)' do
    let(:assignment) { Assignment.new(id: 1, account_id: 1, service_request_id: 1)}
    context 'for valid data' do
      it 'return true' do
        stub_accept_estimation(assignment.id, assignment.account_id, assignment.service_request_id, 'validStripeToken', 200)
        expect(assignment.accept_estimation('validStripeToken')).to be_truthy
      end
    end
    context 'for invalid data' do
      it 'return false' do
        stub_accept_estimation(assignment.id, assignment.account_id, assignment.service_request_id, 'invalidStripeToken', 400)
        expect(assignment.accept_estimation('invalidStripeToken')).to eq({})
      end
    end
  end
  
  describe '#decline_estimation' do
    let(:assignment) { Assignment.new(id: 1, account_id: 1, service_request_id: 1)}
    context 'for valid data' do
      it 'return true' do
        stub_decline_estimation(assignment.id, assignment.account_id, assignment.service_request_id, 'reason', 200)
        expect(assignment.decline_estimation('reason')).to be_truthy
      end
    end
    context 'for invalid data' do
      it 'return false' do
        stub_decline_estimation(assignment.id, assignment.account_id, assignment.service_request_id, 'reason', 400)
        expect(assignment.decline_estimation('reason')).to eq({})
      end
    end
  end
  
  describe '#consider_estimation' do
    let(:assignment) { Assignment.new(id: 1, account_id: 1, service_request_id: 1)}
    context 'for valid data' do
      it 'return true' do
        stub_consider_estimation(assignment.id, assignment.account_id, assignment.service_request_id, 200)
        expect(assignment.consider_estimation).to be_truthy
      end
    end
    context 'for invalid data' do
      it 'return false' do
        stub_consider_estimation(assignment.id, assignment.account_id, assignment.service_request_id, 400)
        expect(assignment.consider_estimation).to eq({})
      end
    end
  end
end
