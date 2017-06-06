require 'rails_helper'

describe DeviseOverrides do
  let(:extended_class) { Class.new { extend ActiveSupport::Concern } }
  
  describe '.confirmed?' do
    let(:customer) { Customer.new(password: '123451', password_confirmation: '123451', email: 'test@gmail.com') }
    it 'return confirmed status' do
      expect(customer.confirmed?).to eq(customer.active?)
    end
  end
  
  describe '.confirmation_required?' do
    let(:customer) { Customer.new(password: '123451', password_confirmation: '123451', email: 'test@gmail.com') }
    it 'return false' do
      expect(customer.confirmation_required?).to be_falsy
    end
  end
  
  describe '#send_confirmation_instructions' do
    context 'valid customer email' do
      let(:customer) { Customer.new(email: 'test@gmail.com') }
      it 'send confirmation instructions' do
        stub_send_confirmation_instructions(customer.email, "#{ENV['APP_URL']}/confirmation", 200, confirmation_instructions_valid_body)
        customer = Customer.send_confirmation_instructions({email: 'test@gmail.com', redirect_url: "#{ENV['APP_URL']}/confirmation" })
        expect(customer).to be_instance_of(Customer)
        expect(customer.email).to eq(customer.email)
      end
    end
    context 'invalid customer email' do
      let(:customer) { Customer.new(email: 'invalid@gmail.com') }
      it 'return error' do
        stub_send_confirmation_instructions(customer.email, "#{ENV['APP_URL']}/confirmation", 422, confirmation_instructions_invalid_body)
        customer = Customer.send_confirmation_instructions({email: 'invalid@gmail.com', redirect_url: "#{ENV['APP_URL']}/confirmation" })
        expect(customer.errors.messages.has_key?(:email)).to be_truthy
      end
    end
  end
  
  describe '#authenticate!' do
    context 'for valid data' do
      it 'authenticate customer' do
        customer = Customer.new( email: 'test@gmail.com', password: 'test123')
        stub_auth_api_request('test@gmail.com', 'test123', { 'jwt': jwt}, 201 )
        customer.authenticate!
        expect(customer.jwt).to eq(jwt)
      end
    end
    context 'for invalid data' do
      it 'not authenticate customer' do
        customer = Customer.new( email: 'invalid@gmail.com', password: '123456')
        stub_auth_api_request('invalid@gmail.com', '123456', {}, 401 )
        customer.authenticate!
        expect(customer.jwt).to be_nil
      end
    end
  end
  
  describe 'ClassMethods' do
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
          stub_password_reset_instructions('invalid@gmail.com', "#{ENV['APP_URL']}/password/edit", 422, {'email': ['not found'] })
          c = Customer.send_reset_password_instructions({email: 'invalid@gmail.com'})
          expect(c.errors.present?).to be_truthy
          expect(c.errors.full_messages.first).to eq('Email not found')
        end
      end
      context 'valid email' do
        it 'return 200 status' do
          stub_password_reset_instructions('test@gmail.com', "#{ENV['APP_URL']}/password/edit", 200, {})
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
        it 'return error password is blank' do
          c = Customer.reset_password_by_token({password: nil, password_confirmation: '12345678', reset_password_token: @token})
          expect(c.errors.present?).to be_truthy
        end
      end
      context 'password is present and password_cofirmation is nil' do
        it 'return error password confirmation is blank' do
          c = Customer.reset_password_by_token({password: '12345678', password_confirmation: '', reset_password_token: @token})
          expect(c.errors.present?).to be_truthy
        end
      end
      context 'password and password_cofirmation are too short' do
        it 'return error password is too short' do
          stub_password_reset_request('1', '1', @token, 201, {'password': [' is too short (minimum is 8 characters)']}.to_json)
          c = Customer.reset_password_by_token({password: '1', password_confirmation: '1', reset_password_token: @token})
          expect(c).to be_instance_of(Customer)
        end
      end
      context 'password and password_cofirmation are valid' do
        it 'reset the password' do
          customer = Customer.new(password: '12345678', password_confirmation: '12345678', reset_password_token: @token, email: 'test@gmail.com', name: 'Test', jwt: jwt )
          allow(Customer).to receive(:new).with(customer.attributes).and_return(customer)
          allow(customer).to receive(:valid?).and_return(true)
          stub_password_reset_request('12345678', '12345678', @token, 201, verified_return_body)
          cus = Customer.reset_password_by_token(customer.attributes)
          expect(cus.errors.present?).to be_falsy
          expect(cus).to be_instance_of(Customer)
        end
      end
    end
    
    describe '.confirm_by_token(confirmation_token)' do
      before(:each) do
        @customer = Customer.new(confirmation_token: 'hhF__tifmYMhDFc8CwRR')
      end
      context 'user with confirmed email' do
        it 'return error already confirmed' do
          stub_confirm_by_token_request(@customer.confirmation_token, 422, already_confirmed_email_body)
          customer = Customer.confirm_by_token(@customer.confirmation_token)
          expect(customer.errors.messages.has_key?(:email)).to be_truthy
        end
      end
      context 'user with invalid token' do
        it 'return error invalid token' do
          stub_confirm_by_token_request(@customer.confirmation_token, 422, invalid_confirmation_token_body)
          customer = Customer.confirm_by_token(@customer.confirmation_token)
          expect(customer.errors.messages.has_key?(:confirmation_token)).to be_truthy
        end
      end
      context 'user with valid token' do
        it 'return email confirmation' do
          stub_confirm_by_token_request(@customer.confirmation_token, 200, {}.to_json)
          customer = Customer.confirm_by_token(@customer.confirmation_token)
          expect(customer.errors.any?).to be_falsy
        end
      end
    end
    
    describe '.send_confirmation_instructions(attributes={})' do
      let(:customer) { Customer.new(email: 'test@gmail.com') }
      it 'return customer details' do
        allow(Customer).to receive(:new).with({email: 'test@gmail.com'}).and_return(customer)
        expect(customer).to receive(:resend_confirmation_instructions)
        expect(Customer.send_confirmation_instructions({email: 'test@gmail.com'})).to be_instance_of(Customer)
      end
    end
    
    describe '.authenticate!(email, password)' do
      context 'user with valid credentials' do
        it 'authenticate user' do
          stub_auth_api_request('test@gmail.com', 'test123', { 'jwt': jwt}, 201 )
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
  end
  
  describe '.prepended(base)' do
    it 'prepend ClassMethods' do
      devise_overrides = DeviseOverrides.prepended(DeviseOverrides)
      expect(devise_overrides.instance_methods.include?(:send_reset_password_instructions)).to be_truthy
      expect(devise_overrides.instance_methods.include?(:reset_password_by_token)).to be_truthy
      expect(devise_overrides.instance_methods.include?(:confirm_by_token)).to be_truthy
      expect(devise_overrides.instance_methods.include?(:send_confirmation_instructions)).to be_truthy
      expect(devise_overrides.instance_methods.include?(:authenticate!)).to be_truthy
    end
  end
  
end
