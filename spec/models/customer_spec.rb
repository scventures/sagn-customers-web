require 'rails_helper'

describe Customer do
  it 'include Her::Model' do
    expect(Customer.include?(Her::Model)).to be_truthy
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
        confirmation_token: anything
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
   
end

