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
  
  it { expect(Location.has_many(:equipment_items)).to be_truthy }
  it { expect(Location.has_many(:service_requests)).to be_truthy }
  it { expect(Location.belongs_to(:customer)).to be_truthy }
  
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
        phone_number: anything,
        geography: anything,
        foursquare_venue_id: anything
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
  
  describe '#geography=(value)' do
    it 'show return hash' do
      geography = ActionController::Parameters.new(latitude: 111.11, longitude: 11.11)
      location = Location.new(geography: geography.permit(:latitude, :longitude))
      expect(location.geography).to eq({"latitude"=>111.11, "longitude"=>11.11})
    end    
  end
end
