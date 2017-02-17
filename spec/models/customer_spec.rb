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
  
  
  describe "attributes" do
    let(:customer) {Customer.new}
    it "include the :email attribute" do
      expect(customer).to have_attributes(:email => anything)
    end
     it "include the :jwt attribute" do
      expect(customer).to have_attributes(:jwt => anything)
    end
     it "include the :password attribute" do
      expect(customer).to have_attributes(:password => anything)
    end
     it "include the :password_confirmation attribute" do
      expect(customer).to have_attributes(:password_confirmation => anything)
    end
  end
  
  it 'Devise should be RemoteAuthenticatable' do
    expect(Customer.include?(Devise::Models::RemoteAuthenticatable)).to be_truthy
  end
  
  it 'Devise should be recoverable' do
    expect(Customer.include?(Devise::Models::Recoverable)).to be_truthy
  end
  
  describe 'Validations' do
    let(:customer) {Customer.new}
    context "if password_required?" do
      it do
        allow(customer).to receive(:password_required?).and_return(true) 
        expect(customer).to validate_presence_of(:password)
        expect(customer).to validate_confirmation_of(:password)
      end
    end
    
    context "unless password_required?" do
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
        expect(customer[:email]).to eq("test@gmail.com")
        expect(customer[:phone_number]).to eq("+111111111")
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
   
  describe '.authenticate!(email, password)' do
    context 'user with valid credentials' do
      it 'authenticate user' do
        stub_auth_api_request('test@gmail.com', 'test123', { 'jwt': 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE0OTQyMjIxMTAsImF1ZCI6ZmFsc2UsInN1YiI6ImN1c3RvbWVyXzU5In0.8PjEL9nyWtHbJ9X5lt-r1ZXQT5_Y7Y0oClnA8xaSyAs'}, 201 )
        expect(Customer.authenticate!('test@gmail.com', 'test123')).to be_instance_of(Customer)
      end
    end
    context 'user with invalid credentials' do
      it 'not authenticate user' do
        stub_auth_api_request('invalid@gmail.com', '123456', {}, 401 )
        expect(Customer.authenticate!('invalid@gmail.com', '123456')).to eq(nil)
      end
    end
  end 
  
  describe '.send_reset_password_instructions(attributes={})' do
    context 'blank email' do
      it 'return error for blank email' do
        c = Customer.send_reset_password_instructions({})
        expect(c.errors.present?).to be_truthy
        expect(c.errors.full_messages.first).to eq('Email can\'t be blank') 
      end
    end
    context 'invalid email' do
      it 'return error email not found' do
        stub_password_reset_instructions('invalid@gmail.com', "#{Rails.application.secrets.host}/password/edit", 422, {'email': ['not found'] })
        c = Customer.send_reset_password_instructions({email: 'invalid@gmail.com'})
        expect(c.errors.present?).to be_truthy
        expect(c.errors.full_messages.first).to eq('Email not found')
      end
    end
    context 'valid email' do
      it 'return 200 status' do
        stub_password_reset_instructions('test@gmail.com', "#{Rails.application.secrets.host}/password/edit", 200, {})
        c = Customer.send_reset_password_instructions({email: 'test@gmail.com'})
        expect(c.errors.present?).to be_falsy
      end
    end
  end
  
  describe '.reset_password_by_token(attributes={})' do
    before(:each) do
      @token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE0OTQyMjIxMTAsImF1ZCI6ZmFsc2UsInN1YiI6ImN1c3RvbWVyXzU5In0.8PjEL9nyWtHbJ9X5lt-r1ZXQT5_Y7Y0oClnA8xaSyAs'
    end
    context 'password is nil and password_cofirmation is present' do
      it "return error password is blank" do
        c = Customer.reset_password_by_token({password: nil, password_confirmation: '12345678', reset_password_token: @token})
        expect(c.errors.present?).to be_truthy
      end
    end
    context 'password is present and password_cofirmation is nil' do
      it "return error password confirmation is blank" do
        c = Customer.reset_password_by_token({password: '12345678', password_confirmation: '', reset_password_token: @token})
        expect(c.errors.present?).to be_truthy
      end
    end
    context 'password and password_cofirmation are too short' do
      it "return error password is too short" do
        stub_password_reset_request('1', '1', @token, 201, {'password': [' is too short (minimum is 8 characters)']}.to_json)
        c = Customer.reset_password_by_token({password: '1', password_confirmation: '1', reset_password_token: @token})
        expect(c).to be_instance_of(Customer)
      end
    end
    context 'password and password_cofirmation are valid' do
      it 'reset the password' do
        stub_password_reset_request('12345678', '12345678', @token, 200, verified_return_body)
        c = Customer.reset_password_by_token({password: '12345678', password_confirmation: '12345678', reset_password_token: @token})
        expect(c.errors.present?).to be_falsy
        expect(c).to be_instance_of(Customer)
      end
    end
  end
  
  
  describe '#password_required?' do
    context 'password is nil and password_cofirmation is present' do
      it 'return true' do
        c = Customer.new(password: '123451', password_confirmation: nil)
        expect(c.password_required?).to be_truthy
      end
    end
    context 'password is present and password_cofirmation is nil' do
      it 'return true' do
        c = Customer.new(password: nil, password_confirmation: '123451')
        expect(c.password_required?).to be_truthy
      end
    end
    context 'password and password_cofirmation are nil' do
      it 'return false' do
        c = Customer.new(password: nil, password_confirmation: nil)
        expect(c.password_required?).to be_falsy
      end
    end
  end
end

