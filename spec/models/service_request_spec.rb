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
    it 'include the :location_id attribute' do
      expect(service_request).to have_attributes(:location_id => anything)
    end
    it 'include the :equipment_id attribute' do
      expect(service_request).to have_attributes(:equipment_id => anything)
    end
    it 'include the :model attribute' do
      expect(service_request).to have_attributes(:model => anything)
    end
    it 'include the :serial attribute' do
      expect(service_request).to have_attributes(:serial => anything)
    end
    it 'include the :brand_name attribute' do
      expect(service_request).to have_attributes(:brand_name => anything)
    end
    it 'include the :category_id attribute' do
      expect(service_request).to have_attributes(:category_id => anything)
    end
    it 'include the :subcategory_id attribute' do
      expect(service_request).to have_attributes(:subcategory_id => anything)
    end
    it 'include the :urgent attribute' do
      expect(service_request).to have_attributes(:urgent => anything)
    end
    it 'include the :problem attribute' do
      expect(service_request).to have_attributes(:problem => anything)
    end
    it 'include the :account_id attribute' do
      expect(service_request).to have_attributes(:account_id => anything)
    end
    it 'include the :equipmemt_warranty attribute' do
      expect(service_request).to have_attributes(:equipmemt_warranty => anything)
    end
    it 'include the :work_time_details attribute' do
      expect(service_request).to have_attributes(:work_time_details => anything)
    end
    it 'include the :customer_accounts_contractor_id attribute' do
      expect(service_request).to have_attributes(:customer_accounts_contractor_id => anything)
    end
    it 'include the :select_guy attribute' do
      expect(service_request).to have_attributes(:select_guy => anything)
    end
  end
  
  describe 'Validations' do
    let(:service_request) {ServiceRequest.new}
    it do
      expect(service_request).to validate_presence_of(:location_id)
    end
  end
  
end

