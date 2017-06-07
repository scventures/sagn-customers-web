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
  
  it { expect(Staff.belongs_to(:account)).to be_truthy }
  
  describe 'Callbacks' do
    it { is_expected.to callback(:set_name).before(:save) }
  end
  
  describe 'attributes' do
    let(:staff) {Staff.new}
    it 'include attributes' do
      expect(staff).to have_attributes(
        id: anything,
        name: anything,
        first_name: anything,
        last_name: anything,
        email: anything,
        _destroy: anything,
      )
    end
  end
  
  describe 'Validations' do
    let(:staff) {Staff.new}
    it do
      expect(staff).to validate_presence_of(:email)
      expect(staff).to validate_presence_of(:first_name)
      expect(staff).to validate_presence_of(:last_name)
    end
  end
  
  describe '#set_name' do
    context 'first_name and last_name are present' do
      let(:staff) { Staff.new(first_name: 'First', last_name: 'Last') }
      it 'return name' do
        expect(staff.set_name).to eq("#{staff.first_name} #{staff.last_name}")
      end
    end
    context 'first_name is present and last_name is nil' do
      let(:staff) { Staff.new(first_name: 'First') }
      it 'return name' do
        expect(staff.set_name).to eq("#{staff.first_name}")
      end
    end
    context 'first_name is nil and last_name is present' do
      let(:staff) { Staff.new(last_name: 'Last') }
      it 'return name' do
        expect(staff.set_name).to eq("#{staff.last_name}")
      end
    end
    context 'first_name and last_name are nil' do
      let(:staff) { Staff.new() }
      it 'return name' do
        expect(staff.set_name).to eq('')
      end
    end
  end
  
end
