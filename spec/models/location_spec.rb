require 'rails_helper'

describe Location do
  it 'include Her::Model' do
    expect(Location.include?(Her::Model)).to be_truthy
  end
  
  it 'parse_root_in_json true' do
    expect(Location.parse_root_in_json?).to eq(:location)
  end
  
  it 'include_root_in_json true' do
    expect(Location.include_root_in_json?).to be_truthy
  end
  
  it 'have collection path customers/accounts/:account_id/locations' do
    expect(Location.collection_path).to eq('customers/accounts/:account_id/locations')
  end
  
  it 'have collection path customers/accounts/:account_id/service_requests' do
    expect(ServiceRequest.collection_path).to eq('customers/accounts/:account_id/service_requests')
  end
  
  it { expect(Location.association_names.include? :equipment_items).to be_truthy }
  
  describe 'attributes' do
    let(:location) {Location.new}
    it 'include attributes' do
      expect(location).to have_attributes(
        id: anything,
        name: anything,
        address_1: anything,
        address_2: anything,
        address_3: anything,
        city: anything,
        state: anything,
        zip: anything,
        latitude: anything,
        longitude: anything
      )
    end
  end
  
  describe '#full_address' do
    let(:location) { Location.new(address_1: 'address_1', address_2: 'address_2', address_3: 'address_3', city: 'city', state: 'state', zip: 'zip')}
    it 'return full address for location' do
      address = 'address_1, address_2, address_3, city, state, zip'
      expect(location.full_address).to eq(address)
    end
  end
end
