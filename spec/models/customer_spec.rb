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
  
  it { expect(Customer.association_names.include? :accounts).to be_truthy }
  it { expect(Customer.association_names.include? :current_account).to be_truthy }
  
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
  
  describe 'Validations' do
    let(:customer) {Customer.new}
    context 'if password_required?' do
      it do
        allow(customer).to receive(:password_required?).and_return(true) 
        expect(customer).to validate_presence_of(:password)
        expect(customer).to validate_confirmation_of(:password)
      end
    end
    
    context 'unless password_required?' do
      it do
        allow(customer).to receive(:password_required?).and_return(false) 
        expect(customer).not_to validate_presence_of(:password)
        expect(customer).not_to validate_confirmation_of(:password)
      end
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
        stub_auth_api_request('test@gmail.com', 'test123', { 'jwt': 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE0OTQyMjIxMTAsImF1ZCI6ZmFsc2UsInN1YiI6ImN1c3RvbWVyXzU5In0.8PjEL9nyWtHbJ9X5lt-r1ZXQT5_Y7Y0oClnA8xaSyAs'}, 201 )
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
   
end

