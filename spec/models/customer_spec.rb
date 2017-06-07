require 'rails_helper'

describe Customer do
  it 'include Her::Model' do
    expect(Customer.include?(Her::Model)).to be_truthy
  end
  
  it 'include Her::FileUpload' do
    expect(Customer.include?(Her::FileUpload)).to be_truthy
  end
  
  it 'extend Devise::Models' do
    expect(Customer.include?(Devise::Models::RemoteAuthenticatable)).to be_truthy
    expect(Customer.include?(Devise::Models::Authenticatable)).to be_truthy
    expect(Customer.include?(Devise::Models::Recoverable)).to be_truthy
  end
  
  it 'prepend DeviseOverrides' do
    expect(Customer.include?(DeviseOverrides)).to be_truthy
  end
  
  it 'include_root_in_json' do
    expect(Customer.include_root_in_json?).to be_truthy 
  end
  
  it 'have resource path customers/viewer' do
    expect(Customer.resource_path).to eq('customers/viewer')
  end
  
  it { expect(Customer.has_many(:accounts)).to be_truthy }
  it { expect(Customer.has_one(:service_request)).to be_truthy }
  it { expect(Customer.has_one(:location)).to be_truthy }
  it { expect(Customer.belongs_to(:current_account)).to be_truthy }
  
  describe 'accept_nested_attributes_for :service_request' do
    let(:customer) { Customer.new(service_request_attributes: { location_id: 1 })}
    it do
      expect(customer.service_request.location_id).to eq(1)
    end
  end
  
  describe 'accept_nested_attributes_for :location' do
    let(:customer) { Customer.new(location_attributes: { name: 'Test' })}
    it do
      expect(customer.location.name).to eq('Test')
    end
  end
  
  describe 'attributes' do
    let(:customer) {Customer.new}
    it 'include attributes' do
      expect(customer).to have_attributes(
        email: anything,
        jwt: anything,
        password: anything,
        password_confirmation: anything,
        active: anything,
        current_account_id: anything,
        customer_account_ids: anything,
        name: anything,
        customer_account_name: anything, 
        unconfirmed_phone: anything,
        tos_accepted: anything,
        confirmation_token: anything,
        photo: anything,
        unconfirmed_email: anything,
        sms_confirmation_pin: anything
      )
    end
  end

  it 'Devise should be RemoteAuthenticatable' do
    expect(Customer.include?(Devise::Models::RemoteAuthenticatable)).to be_truthy
  end
  
  it 'Devise should be recoverable' do
    expect(Customer.include?(Devise::Models::Recoverable)).to be_truthy
  end
  
  it 'Devise should be registerable' do
    expect(Customer.include?(Devise::Models::Registerable)).to be_truthy
  end
  
  it 'Devise should be confirmable' do
    expect(Customer.include?(Devise::Models::Confirmable)).to be_truthy
  end
  
  describe 'Skip Callbacks' do
    it { is_expected.not_to callback(:postpone_email_change_until_confirmation_and_regenerate_confirmation_token).before(:update) }
  end
  
  it { is_expected.to callback(:set_phone_number).before(:save) }
  
  describe 'Validations' do
    let(:customer) {Customer.new}
    it do
      expect(customer).to validate_presence_of(:name)
      expect(customer).to validate_presence_of(:email)
      expect(customer).to validate_presence_of(:customer_account_name)
      expect(customer).to validate_presence_of(:password)
      expect(customer).to validate_confirmation_of(:password)
    end
  end
  
  describe 'has_file_upload' do
    let(:customer) { Customer.new()}
    it ':photo' do
      expect(customer).to respond_to(:avatar)
      expect(customer).to respond_to('avatar=')
      expect(customer).to respond_to('avatar?')
    end
  end
  
  describe '#valid_auth_token?' do
    before(:each) do
      payload1 = {data: 'test@gmail.com'}
      token1 = JWT.encode payload1, nil, 'none'
      @c1 = Customer.new(jwt: token1)
      @decoded_token1 = [{'data'=>'test@gmail.com'}, {'typ'=>'JWT', 'alg'=>'none'}]
      payload2 = {data: 'test@gmail.com', exp: Time.now - 1.hours}
      token2 = JWT.encode payload2, nil, 'none'
      @c2 = Customer.new(jwt: token2)
      @c3 = Customer.new
    end
    context 'jwt is present' do
      it 'return true if token is valid and not expired' do
        expect(@c1.valid_auth_token?).to eq(@decoded_token1)
      end
      it 'return false if token is invalid and expired' do
        expect(@c2.valid_auth_token?).to be_falsy
      end
    end
    context 'jwt is not present' do
      it 'return nil' do
        expect(@c3.valid_auth_token?).to eq(nil)
      end
    end
  end
  
  describe '#populate_attributes' do
    context 'user with valid auth token' do
      it 'populates user attributes' do
        stub_auth_api_request('test@gmail.com', 'test123', { 'jwt': jwt }, 201 )
        customer = Customer.authenticate!('test@gmail.com', 'test123')
        stub_verified_api_request(customer.jwt, verified_return_body , 201)
        customer = customer.populate_attributes
        expect(customer[:email]).to eq('test@gmail.com')
        expect(customer[:phone_number]).to eq('+111111111')
      end
    end
    context 'user with invalid auth token' do
      it 'return nil' do
        customer = Customer.new
        stub_verified_api_request(customer.jwt, nil , 401)
        customer = customer.populate_attributes
        expect(customer).to eq(nil)
      end
    end
  end
  
  describe '#confirmable_email' do
    before(:each) do
      @customer = Customer.new(email: 'confirmed_email@gmail.com', unconfirmed_email: 'unconfirmed_email@gmail.com')
    end
    context 'pending_reconfirmation is true' do
      it 'return confirmable_email as unconfirmed_email' do
        allow(@customer).to receive(:pending_reconfirmation?).and_return(true)
        expect(@customer.confirmable_email).to eq(@customer.unconfirmed_email)
      end
    end
    context 'pending_reconfirmation is false' do
      it 'return confirmable_email as email' do
        allow(@customer).to receive(:pending_reconfirmation?).and_return(false)
        expect(@customer.confirmable_email).to eq(@customer.email)
      end
    end
  end
  
  describe '#confirmation_pending?' do
    before(:each) do
      @customer = Customer.new(email: 'test@gmail.com')
    end
    context 'confirmed and pending_confirmation are true' do
      it 'return true' do
        @customer.unconfirmed_email = 'test@gmail.com'
        allow(@customer).to receive(:confirmed?).and_return(true)
        allow(@customer).to receive(:pending_confirmation?).and_return(true)
        expect(@customer.confirmation_pending?).to be_truthy
      end
    end
    context 'confirmed and pending_confirmation are false' do
      it 'return true' do
        allow(@customer).to receive(:confirmed?).and_return(false)
        allow(@customer).to receive(:pending_confirmation?).and_return(false)
        expect(@customer.confirmation_pending?).to be_truthy
      end
    end
    context 'confirmed is true and pending_confirmation is false' do
      it 'return false' do
        allow(@customer).to receive(:confirmed?).and_return(true)
        allow(@customer).to receive(:pending_confirmation?).and_return(false)
        expect(@customer.confirmation_pending?).to be_falsy
      end
    end
    context 'confirmed is false and pending_confirmation is true' do
      it 'return true' do
        allow(@customer).to receive(:confirmed?).and_return(false)
        allow(@customer).to receive(:pending_confirmation?).and_return(true)
        expect(@customer.confirmation_pending?).to be_truthy
      end
    end
  end
  
  describe '#phone_confirmation_pending?' do
    context 'unconfirmed_phone is present and unconfirmation phone not equal to phone_number' do
      let(:customer) { Customer.new(unconfirmed_phone: '+11111111111') }
      it 'return true' do
        allow(customer).to receive(:phone_number).and_return('+22222222')
        expect(customer.phone_confirmation_pending?).to be_truthy
      end
    end
    context 'unconfirmed_phone is present and unconfirmation phone equal to phone_number' do
      let(:customer) { Customer.new(unconfirmed_phone: '+11111111111') }
      it 'return true' do
        allow(customer).to receive(:phone_number).and_return('+11111111111')
        expect(customer.phone_confirmation_pending?).to be_falsy
      end
    end
    context 'unconfirmed_phone is not present and unconfirmation phone not equal to phone_number' do
      let(:customer) { Customer.new() }
      it 'return true' do
        allow(customer).to receive(:phone_number).and_return('+11111111111')
        expect(customer.phone_confirmation_pending?).to be_falsy
      end
    end
  end
  
  describe '#resend_phone_confirmation_instructions' do
    context 'valid phone number' do
      let(:customer) { Customer.new(unconfirmed_phone: '+111111111111') }
      it 'send confirmation instruction' do
        stub_resend_phone_confirmation_instructions(customer.unconfirmed_phone, 200, confirmation_instructions_valid_body)
        customer.resend_phone_confirmation_instructions
        expect(customer.errors.present?).to be_falsy
      end
    end
    context 'invalid phone number' do
      let(:customer) { Customer.new(unconfirmed_phone: '+22222222') }
      it 'return errors' do
        stub_resend_phone_confirmation_instructions(customer.unconfirmed_phone, 400, resend_phone_confirmation_invalid_body)
        customer.resend_phone_confirmation_instructions
        expect(customer.errors.present?).to be_truthy
      end
    end
  end

  describe '#verify_phone' do
    context 'valid phone number' do
      let(:customer) { Customer.new(sms_confirmation_pin: '0000') }
      it 'verify phone number' do
        stub_verify_phone(customer.sms_confirmation_pin, 200, confirmation_instructions_valid_body)
        expect(customer.verify_phone).to be_truthy
      end
    end
    context 'invalid phone number' do
      let(:customer) { Customer.new(sms_confirmation_pin: '1111') }
      it 'return errors' do
        stub_verify_phone(customer.sms_confirmation_pin, 400, ''.to_json)
        expect(customer.verify_phone).to be_falsy
      end
    end
  end
  
  describe '#create_or_find_location' do
    let(:customer) { Customer.new(current_account_id: 1) }
    context 'location not exists with valid data' do
      it 'return location' do
        params = {'address_1'=>'Address', 'geography'=>{'latitude'=>'11.11', 'longitude'=>'11.11'}, 'name'=>'Test'}
        location = Location.new(_account_id: 1, name: 'Test', address_1: 'Address', geography: { latitude: '11.11', longitude: '11.11'})
        allow(customer).to receive(:location).and_return(location)
        stub_create_location(1, params, 200, customer_location)
        location = customer.create_or_find_location
        expect(location.address_1).to eq('Address')
        expect(location.name).to eq('Test')
      end
    end
    context 'location exists with name' do
      it 'return location' do
        params = {'account_id'=>'1', 'address_1'=>'Address 1', 'geography'=>{'latitude'=>'11.11', 'longitude'=>'11.11'}, 'name'=>'Test Location 2'}
        location = Location.new(_account_id: 1, name: 'Test Location 2', address_1: 'Address 1', geography: { latitude: '11.11', longitude: '11.11'})
        allow(customer).to receive(:location).and_return(location)
        stub_create_location(1, params, 400, location_with_name_error)
        stub_verified_api_request(jwt, verified_return_body, 201)
        customer.populate_attributes
        location.account_id = customer.current_account_id
        account = Account.new(id: 1, name: 'Test', phone_number: nil, have_payment_method: true, owner_name: 'Test', owner_email: 'test@gmail.com')
        allow(customer).to receive(:current_account).and_return(account)
        stub_customer_locations(1, 200, customer_locations)
        location = customer.create_or_find_location
        expect(location.name).to eq('Test Location 2')
      end
    end
    context 'location exists with address' do
      it 'return location' do
        params = {'account_id'=>'1', 'address_1'=>'Address 2', 'geography'=>{'latitude'=>'11.11', 'longitude'=>'11.11'}, 'name'=>'Test Location 2'}
        location = Location.new(_account_id: 1, name: 'Test Location 2', address_1: 'Address 2', geography: { latitude: '11.11', longitude: '11.11'})
        allow(customer).to receive(:location).and_return(location)
        stub_create_location(1, params, 400, location_with_address_error)
        stub_verified_api_request(jwt, verified_return_body, 201)
        customer.populate_attributes
        location.account_id = customer.current_account_id
        account = Account.new(id: 1, name: 'Test', phone_number: nil, have_payment_method: true, owner_name: 'Test', owner_email: 'test@gmail.com')
        allow(customer).to receive(:current_account).and_return(account)
        stub_customer_locations(1, 200, customer_locations)
        location = customer.create_or_find_location
        expect(location.address_1).to eq('Address 2')
      end
    end
    context 'location not exists with invalid data' do
      it 'return false' do
        params = {'address_1'=>'Address 3', 'geography'=>{'latitude'=>'11.11', 'longitude'=>'11.11'}, 'name'=>'Test Location 3'}
        location = Location.new(_account_id: 1, name: 'Test Location 3', address_1: 'Address 3', geography: { latitude: '11.11', longitude: '11.11'})
        allow(customer).to receive(:location).and_return(location)
        stub_create_location(1, params, 400, {}.to_json)
        location = customer.create_or_find_location
        expect(location).to be_nil
      end
    end
  end
  
  describe 'create_service_request' do
    let(:customer) { Customer.new(current_account_id: 1) }
    context 'location is present' do 
      it 'create service request' do
        location = Location.new(account_id: 1, name: 'Test Location 2', address_1: 'Address 1', geography: { latitude: '11.11', longitude: '11.11'})
        stub_verified_api_request(jwt, verified_return_body, 201)
        location = Location.new(name: 'Test Location', address_1: 'Address', geography: { latitude: '11.11', longitude: '11.11'})
        allow(customer).to receive(:location).and_return(location)
        allow(customer).to receive(:current_account_id).and_return(1)
        allow(customer).to receive(:create_or_find_location).and_return(location)
        service_request = ServiceRequest.new(account_id: "1", location_id: "1", category_id: "1", subcategory_id: "1", urgent: 'false')
        allow(customer).to receive(:service_request).and_return(service_request)
        allow(location).to receive(:id).and_return(1)
        stub_create_service_request(service_request, 200, service_request_body)
        service_request = customer.create_service_request
        expect(service_request).not_to be_nil
        expect(service_request.location_id).to eq(1)
        expect(service_request.id).not_to be_nil
      end
    end
    context 'location is nil' do
      it 'return nil' do
        stub_verified_api_request(jwt, verified_return_body, 201)
        location = Location.new(name: 'Test Location', address_1: 'Address', geography: { latitude: '11.11', longitude: '11.11'})
        allow(customer).to receive(:location).and_return(location)
        allow(customer).to receive(:current_account_id).and_return(1)
        allow(customer).to receive(:create_or_find_location).and_return(nil)
        service_request = customer.create_service_request
        expect(service_request).to be_nil
      end
    end
  end
  
  describe '#set_phone_number' do
    let(:customer) { Customer.new(unconfirmed_phone: '+1 111-111-1111')}
    context 'if unconfirmed_phone is present' do
      it 'set phone number' do
        expect(customer.set_phone_number). to eq('11111111111')
      end
    end
  end
  
  describe '#get_layer_identity_token(nonce)' do
    let(:customer) { Customer.new }
    it do
      stub_layer_identity_token('testnonce', { 'token': 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImN0eSI6ImxheWVyLWVpdDt2P'}, 200)
      token = customer.get_layer_identity_token('testnonce')
      expect(token).to eq(token)
    end
  end
   
end

