require 'rails_helper'

describe Account do
  it 'include Her::Model' do
    expect(Account.include?(Her::Model)).to be_truthy
  end
  
  it 'parse_root_in_json :customer_account' do
    expect(Account.parse_root_in_json?).to eq(:customer_account)
  end
  
  it 'have collection path customers/accounts' do
    expect(Account.collection_path).to eq('customers/accounts')
  end
  
  it { expect(Account.association_names.include? :locations).to be_truthy }
  it { expect(Account.association_names.include? :contractors).to be_truthy }
  
  describe 'attributes' do
    let(:account) {Account.new}
    it 'include the :id attribute' do
      expect(account).to have_attributes(:id => anything)
    end
  end
  
end
