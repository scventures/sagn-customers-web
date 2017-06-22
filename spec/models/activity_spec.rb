require 'rails_helper'

describe Activity do
  it 'include Her::Model' do
    expect(Activity.include?(Her::Model)).to be_truthy
  end
  
  it 'parse_root_in_json true' do
    expect(Activity.parse_root_in_json?).to be_truthy
  end
  
  it { expect(Activity.belongs_to(:service_request)).to be_truthy }
 
  describe '#customer_accepted?' do
    let(:activity) { Activity.new }
    context 'if action is customer_accepted' do
      it 'return true' do
        activity.action = 'customer_accepted'
        expect(activity.customer_accepted?).to be_truthy
      end
    end
    context 'if action is not customer_accepted' do
      it 'return false' do
        expect(activity.customer_accepted?).to be_falsy
      end
    end
  end
  
  describe '#customer_declined?' do
    let(:activity) { Activity.new }
    context 'if action is customer_declined' do
      it 'return true' do
        activity.action = 'customer_declined'
        expect(activity.customer_declined?).to be_truthy
      end
    end
    context 'if action is not customer_declined' do
      it 'return false' do
        expect(activity.customer_declined?).to be_falsy
      end
    end
  end
  
  describe '#accepted?' do
    let(:activity) { Activity.new }
    context 'if action is accepted' do
      it 'return true' do
        activity.action = 'accepted'
        expect(activity.accepted?).to be_truthy
      end
    end
    context 'if action is not accepted' do
      it 'return false' do
        expect(activity.accepted?).to be_falsy
      end
    end
  end
  
  describe '#declined?' do
    let(:activity) { Activity.new }
    context 'if action is declined' do
      it 'return true' do
        activity.action = 'declined'
        expect(activity.declined?).to be_truthy
      end
    end
    context 'if action is not declined' do
      it 'return false' do
        expect(activity.declined?).to be_falsy
      end
    end
  end
  
  describe '#assignment' do
    context 'trackable_type is ServiceRequestsAssignment' do
      it 'return activity assignment' do
        activity = Activity.new(trackable_type: 'ServiceRequestsAssignment', trackable_id: 10)
        activity.service_request = ServiceRequest.new(id: 1)
        activity.service_request.attributes = {service_requests_assignments: [{id: 1}, {id: 10}]}
        assignment = activity.assignment
        expect(assignment[:id]).to eq(10)
      end
    end
  end
  
  describe '#estimation' do
    context 'trackable_type is Estimation' do
      it 'return activity estimation' do
        activity = Activity.new(trackable_type: 'Estimation', trackable_id: 10)
        activity.service_request = ServiceRequest.new(id: 1)
        activity.service_request.attributes = {service_requests_assignments: [{id: 1, estimations: [{id: 10}, {id: 20}]}, {id: 2, estimations: [{id: 11}]}]}
        estimation = activity.estimation
        expect(estimation[:id]).to eq(10)
      end
    end
  end
  
end

