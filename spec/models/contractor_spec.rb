require 'rails_helper'

describe Contractor do
  it 'include Her::Model' do
    expect(Contractor.include?(Her::Model)).to be_truthy
  end
  
  it 'have collection path customers/accounts/:customer_account_id/contractors' do
    expect(Contractor.collection_path).to eq('customers/accounts/:customer_account_id/contractors')
  end
  
  it 'parse_root_in_json :customer_accounts_contractors' do
    expect(Contractor.parse_root_in_json?).to eq(:customer_accounts_contractors)
  end
  
  it { expect(Contractor.association_names.include? :account).to be_truthy }
  
  describe 'attributes' do
    let(:contractor) {Contractor.new}
    it 'include the :id attribute' do
      expect(contractor).to have_attributes(:id => anything)
    end
    it 'include the :customer_account_id attribute' do
      expect(contractor).to have_attributes(:customer_account_id => anything)
    end
    it 'include the :contractor_id attribute' do
      expect(contractor).to have_attributes(:contractor_id => anything)
    end
    it 'include the :contractor_name attribute' do
      expect(contractor).to have_attributes(:contractor_name => anything)
    end
    it 'include the :contractor_account_id attribute' do
      expect(contractor).to have_attributes(:contractor_account_id => anything)
    end
    it 'include the :contractor_account_name attribute' do
      expect(contractor).to have_attributes(:contractor_account_name => anything)
    end
    it 'include the :business_name attribute' do
      expect(contractor).to have_attributes(:business_name => anything)
    end
    it 'include the :contact_name attribute' do
      expect(contractor).to have_attributes(:contact_name => anything)
    end
    it 'include the :email attribute' do
      expect(contractor).to have_attributes(:email => anything)
    end
    it 'include the :phone_number attribute' do
      expect(contractor).to have_attributes(:phone_number => anything)
    end
    it 'include the :status attribute' do
      expect(contractor).to have_attributes(:status => anything)
    end
  end
end
