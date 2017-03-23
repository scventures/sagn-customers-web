require 'rails_helper'

describe Staff do
  it 'include Her::Model' do
    expect(Staff.include?(Her::Model)).to be_truthy
  end
  
  it 'parse_root_in_json true' do
    expect(Staff.parse_root_in_json?).to eq(:customer_account_customers)
  end
  
  it 'include_root_in_json true' do
    expect(Staff.include_root_in_json?).to be_truthy
  end
  
  it 'have collection path customers/accounts/:account_id/locations' do
    expect(Staff.collection_path).to eq('customers/accounts/:account_id/staff')
  end
  
  it 'have resource path customers/accounts/:account_id/staff/:id' do
    expect(Staff.resource_path).to eq('customers/accounts/:account_id/staff/:id')
  end
  
  it { expect(Staff.association_names.include? :account).to be_truthy }
  
  describe 'attributes' do
    let(:staff) {Staff.new}
    it 'include attributes' do
      expect(staff).to have_attributes(
        id: anything,
        name: anything,
        email: anything
      )
    end
  end
  
end
