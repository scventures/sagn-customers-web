require 'rails_helper'

describe Contractor do
  it 'include Her::Model' do
    expect(Contractor.include?(Her::Model)).to be_truthy
  end
  
  it 'have collection path customers/accounts/:account_id/contractors' do
    expect(Contractor.collection_path).to eq('customers/accounts/:account_id/contractors')
  end

  it 'have resource path customers/accounts/:account_id/contractors/:id' do
    expect(Contractor.resource_path).to eq('customers/accounts/:account_id/contractors/:id')
  end

  it 'parse_root_in_json :customer_accounts_contractors' do
    expect(Contractor.parse_root_in_json?).to eq(:customer_accounts_contractors)
  end

  it { expect(Contractor.association_names.include? :account).to be_truthy }
  
  describe 'attributes' do
    let(:contractor) {Contractor.new}
    it 'include attributes' do
      expect(contractor).to have_attributes(
        id: anything,
        customer_account_id: anything,
        contractor_id: anything,
        contractor_name: anything,
        contractor_account_id: anything,
        contractor_account_name: anything,
        business_name: anything,
        contact_name: anything,
        email: anything,
        phone_number: anything,
        status: anything,
        _destroy: anything
      )
    end
  end

  describe 'Validations' do
    let(:contractor) {Contractor.new}
    it do
      expect(contractor).to validate_presence_of(:email)
      expect(contractor).to validate_presence_of(:contact_name)
      expect(contractor).to validate_presence_of(:business_name)
    end
  end
end
