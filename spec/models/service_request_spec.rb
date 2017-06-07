require 'rails_helper'

describe ServiceRequest do
  it 'include Her::Model' do
    expect(ServiceRequest.include?(Her::Model)).to be_truthy
  end
  
  it 'parse_root_in_json true' do
    expect(ServiceRequest.parse_root_in_json?).to be_truthy
  end
  
  it 'include_root_in_json true' do
    expect(ServiceRequest.include_root_in_json?).to be_truthy
  end
  
  it 'have collection path customers/accounts/:account_id/service_requests' do
    expect(ServiceRequest.collection_path).to eq('customers/accounts/:account_id/service_requests')
  end
  
  it 'have resource path customers/accounts/:account_id/service_requests/:id' do
    expect(ServiceRequest.resource_path).to eq('customers/accounts/:account_id/service_requests/:id')
  end
  
  it { expect(ServiceRequest.has_many(:issue_images)).to be_truthy }
  it { expect(ServiceRequest.has_many(:activities)).to be_truthy }
  it { expect(ServiceRequest.has_many(:assignments)).to be_truthy }
  it { expect(ServiceRequest.has_many(:estimations)).to be_truthy }
  
   describe 'accept_nested_attributes_for :issue_images' do
    let(:service_request) { ServiceRequest.new(issue_images_attributes: { 0 => { image: 'Test1.png' }, 1 => { image: 'Test2.png' }})}
    it do
      expect(service_request.issue_images[0].image).to eq('Test1.png')
      expect(service_request.issue_images[1].image).to eq('Test2.png')
    end
  end
  
  describe 'attributes' do
    let(:service_request) {ServiceRequest.new}
    it 'include attributes' do
      expect(service_request).to have_attributes(
        location_id: anything,
        equipment_item_id: anything,
        model: anything,
        serial: anything,
        brand_name: anything,
        category_id: anything,
        subcategory_id: anything,
        subcategory: anything,
        urgent: anything,
        problem_code_id: anything,
        account_id: anything,
        equipment_warranty: anything,
        work_time_details: anything,
        customer_accounts_contractor_id: anything,
        select_guy: anything,
        catergory_search: anything,
        notes: anything,
        contact_details: anything,
        phone_number: anything,
        token: anything
      )
    end
  end
  
  it { is_expected.to callback(:set_urgent).before(:save) }
  it { is_expected.to callback(:set_brand_and_equipment).before(:save) }
  
  describe 'Validations' do
    let(:service_request) {ServiceRequest.new}
    it do
      expect(service_request).to validate_presence_of(:location_id)
      expect(service_request).to validate_presence_of(:category_id)
      expect(service_request).to validate_presence_of(:subcategory_id)
    end
  end
  
  describe '#assigned?' do
    let(:service_request) { ServiceRequest.new() }
    context 'if status is assigned' do
      it 'return true' do
        service_request.status = 'assigned'
        expect(service_request.assigned?).to be_truthy
      end
    end
    context 'if status is not assigned' do
      it 'return false' do
        expect(service_request.assigned?).to be_falsy
      end
    end
  end
  
  describe '#can_editable?' do
    let(:service_request) { ServiceRequest.new() }
    context 'if status is waiting' do
      it 'return true' do
        service_request.status = 'waiting'
        expect(service_request.can_editable?).to be_truthy
      end
    end
    context 'if status is not waiting' do
      it 'return false' do
        expect(service_request.can_editable?).to be_falsy
      end
    end
  end
  
  describe '#completed?' do
    let(:service_request) { ServiceRequest.new() }
    context 'if status is completed' do
      it 'return true' do
        service_request.status = 'completed'
        expect(service_request.completed?).to be_truthy
      end
    end
    context 'if status is not completed' do
      it 'return false' do
        expect(service_request.completed?).to be_falsy
      end
    end
  end
  
  describe '#cancel' do
    let(:service_request) { ServiceRequest.new(id: 1, account_id: 1) }
    context 'for valid data' do
      it 'return true' do
        stub_cancel_service_request(service_request.id, service_request.account_id, 200, cancel_service_request_success)
        service_request.cancel
        expect(service_request.errors.any?).to be_falsy
      end
    end
    context 'for invalid data' do
      it 'return false' do
        stub_cancel_service_request(service_request.id, service_request.account_id, 400, cancel_service_request_error)
        service_request.cancel
        expect(service_request.errors.any?).to be_truthy
      end
    end
  end
  
  describe '#set_urgent' do
    let(:service_request) { ServiceRequest.new(urgent: 'true')}
    it 'return boolean value for urgent' do
      expect(service_request.set_urgent).to be_truthy
    end
  end
  
  describe '#set_brand_and_equipment' do
    let(:service_request) { ServiceRequest.new() }
    context 'brand_id and equipment_id are valid' do
      it 'return values' do
        service_request.brand_id = 1
        service_request.equipment_item_id = 1
        service_request.set_brand_and_equipment
        expect(service_request.brand_id).to eq(1)
        expect(service_request.equipment_item_id).to eq(1)
      end
    end
    context 'brand_id and equipment_id are invalid' do
      it 'return nil values' do
        service_request.brand_id = "0"
        service_request.equipment_item_id = "0"
        service_request.set_brand_and_equipment
        expect(service_request.brand_id).to be_nil
        expect(service_request.equipment_item_id).to be_nil
      end
    end
  end
  
  describe 'to_params' do
    let(:service_request) { ServiceRequest.new(token: 'testToken') }
    it 'return stripe_token in params' do
      params = service_request.to_params
      expect(params[:stripe_token]).to eq(service_request.token)
      expect(params[:token]).to be_nil
    end
  end
end
