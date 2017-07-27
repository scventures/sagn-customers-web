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
    context 'latitude and longitude are present' do
      it 'should return hash' do
        stub_geocoder_request
        geography = ActionController::Parameters.new(latitude: 111.11, longitude: 11.11)
        location = Location.new(geography: geography.permit(:latitude, :longitude))
        expect(location.geography).to eq({"latitude"=>111.11, "longitude"=>11.11})
      end
    end
    context 'latitude and longitude are not present' do
      describe 'get latitude and longitude from geocoder' do
        context 'geocoder return latitude and longitude' do
          it 'should return hash' do
            stub_geocoder_request
            geography = ActionController::Parameters.new(latitude: '', longitude: '')
            allow(Geocoder).to receive(:coordinates).and_return([11.11, 11.11])
            location = Location.new(geography: geography.permit(:latitude, :longitude))
            expect(location.geography).to eq({"latitude"=>11.11, "longitude"=>11.11})
          end
        end
        context 'geocoder return nil' do
          it 'should return error' do
            stub_geocoder_request
            geography = ActionController::Parameters.new(latitude: '', longitude: '')
            allow(Geocoder).to receive(:coordinates).and_return(nil)
            location = Location.new(geography: geography.permit(:latitude, :longitude))
            location.geography
            expect(location.errors[:address_1].join(', ')).not_to eq(nil)
          end
        end
      end
    end
  end
  
  describe '#create_or_find_location' do
    let(:customer) { Customer.new(current_account_id: 1) }
    let(:account) { Account.new(id: 1) }
    context 'location not exists with valid data' do
      it 'return location' do
        stub_geocoder_request
        allow(Geocoder).to receive(:coordinates).and_return(nil)
        params = {'address_1'=>'Address', 'geography'=>{'latitude'=>'11.11', 'longitude'=>'11.11'}, 'name'=>'Test'}
        location = Location.new(_account_id: 1, name: 'Test', address_1: 'Address', geography: { latitude: '11.11', longitude: '11.11'})
        stub_create_location(1, params, 200, customer_location)
        location = location.create_or_find_location(account)
        expect(location.address_1).to eq('Address')
        expect(location.name).to eq('Test')
      end
    end
    context 'location exists with name' do
      it 'return location' do
        stub_geocoder_request
        allow(Geocoder).to receive(:coordinates).and_return(nil)
        params = {'account_id'=>'1', 'address_1'=>'Address 1', 'geography'=>{'latitude'=>'11.11', 'longitude'=>'11.11'}, 'name'=>'Test Location 2'}
        location = Location.new(_account_id: 1, name: 'Test Location 2', address_1: 'Address 1', geography: { latitude: '11.11', longitude: '11.11'})
        stub_create_location(1, params, 400, location_with_name_error)
        stub_verified_api_request(jwt, verified_return_body, 201)
        customer.populate_attributes
        location.account_id = customer.current_account_id
        account = Account.new(id: 1, name: 'Test', phone_number: nil, have_payment_method: true, owner_name: 'Test', owner_email: 'test@gmail.com')
        allow(customer).to receive(:current_account).and_return(account)
        stub_customer_locations(1, 200, customer_locations)
        location = location.create_or_find_location(account)
        expect(location.name).to eq('Test Location 2')
      end
    end
    context 'location exists with address' do
      it 'return location' do
        stub_geocoder_request
        allow(Geocoder).to receive(:coordinates).and_return(nil)
        params = {'account_id'=>'1', 'address_1'=>'Address 2', 'geography'=>{'latitude'=>'11.11', 'longitude'=>'11.11'}, 'name'=>'Test Location 2'}
        location = Location.new(_account_id: 1, name: 'Test Location 2', address_1: 'Address 2', geography: { latitude: '11.11', longitude: '11.11'})
        stub_create_location(1, params, 400, location_with_address_error)
        stub_verified_api_request(jwt, verified_return_body, 201)
        customer.populate_attributes
        location.account_id = customer.current_account_id
        account = Account.new(id: 1, name: 'Test', phone_number: nil, have_payment_method: true, owner_name: 'Test', owner_email: 'test@gmail.com')
        allow(customer).to receive(:current_account).and_return(account)
        stub_customer_locations(1, 200, customer_locations)
        location = location.create_or_find_location(account)
        expect(location.address_1).to eq('Address 2')
      end
    end
    context 'location not exists with invalid data' do
      it 'return false' do
        stub_geocoder_request
        allow(Geocoder).to receive(:coordinates).and_return(nil)
        params = {'address_1'=>'Address 3', 'geography'=>{'latitude'=>'11.11', 'longitude'=>'11.11'}, 'name'=>'Test Location 3'}
        location = Location.new(_account_id: 1, name: 'Test Location 3', address_1: 'Address 3', geography: { latitude: '11.11', longitude: '11.11'})
        stub_create_location(1, params, 400, {}.to_json)
        location = location.create_or_find_location(account)
        expect(location).to be_nil
      end
    end
  end
end
