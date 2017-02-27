require 'rails_helper'

describe ServiceRequest do
  it 'include Her::Model' do
    expect(ServiceRequest.include?(Her::Model)).to be_truthy
  end
  
  it 'include_root_in_json true' do
    expect(ServiceRequest.include_root_in_json?).to be_truthy
  end
  
  it 'have collection path customers/accounts/:account_id/service_requests' do
    expect(ServiceRequest.collection_path).to eq('customers/accounts/:account_id/service_requests')
  end
  
  it { expect(ServiceRequest.association_names.include? :issue_images).to be_truthy }
  
  describe 'attributes' do
    let(:service_request) {ServiceRequest.new}
    it 'include attributes' do
      expect(service_request).to have_attributes(
        location_id: anything,
        equipment_id: anything,
        model: anything,
        serial: anything,
        brand_name: anything,
        category_id: anything,
        subcategory_id: anything,
        urgent: anything,
        problem: anything,
        account_id: anything,
        equipmemt_warranty: anything,
        work_time_details: anything,
        customer_accounts_contractor_id: anything,
        select_guy: anything
      )
    end
  end
  
  describe 'Validations' do
    let(:service_request) {ServiceRequest.new}
    it do
      expect(service_request).to validate_presence_of(:location_id)
      expect(service_request).to validate_presence_of(:category_id)
      expect(service_request).to validate_presence_of(:subcategory_id)
    end
  end
  
end

