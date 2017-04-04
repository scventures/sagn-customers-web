require 'rails_helper'
include Shoulda::Matchers::ActiveRecord
describe Account, type: :model do
  it 'include Her::Model' do
    expect(Account.include?(Her::Model)).to be_truthy
  end
  
  it 'parse_root_in_json :customer_account' do
    expect(Account.parse_root_in_json?).to eq(:customer_account)
  end
  
  it 'have collection path customers/accounts' do
    expect(Account.resource_path).to eq('customers/accounts/:id')
  end
  
  it { expect(Account.association_names.include? :locations).to be_truthy }
  it { expect(Account.association_names.include? :contractors).to be_truthy }
  it { expect(Account.association_names.include? :staff).to be_truthy }
  
  describe 'accept_nested_attributes_for :contractors' do
    let(:account) { Account.new(contractors_attributes: { 0 => {contact_name: 'Test', business_name: 'Test'}, 1 => {email: 'test1@gmail.com'}})}
    it do
      expect(account.contractors.first.contact_name).to eq('Test')
      expect(account.contractors.first.business_name).to eq('Test')
      expect(account.contractors[1].email).to eq('test1@gmail.com')
    end
  end
  
  describe 'accept_nested_attributes_for :staff' do
    let(:account) { Account.new(staff_attributes: { 0 => {name: 'Test'}, 1 => {email: 'test@gmail.com'}})}
    it do
      expect(account.staff.first.name).to eq('Test')
      expect(account.staff[1].email).to eq('test@gmail.com')
    end
  end

  describe 'attributes' do
    let(:account) {Account.new}
    it 'include attributes' do
      expect(account).to have_attributes(id: anything)
    end
  end
  
end
