require 'rails_helper'

describe Customer do
  it "should incliude Her::Model" do
    Customer.include?(Her::Model).should be true
  end
  it "should exten all Devise::Models" do
    Customer.include?(Devise::Models::RemoteAuthenticatable).should be true
    Customer.include?(Devise::Models::Authenticatable).should be true
  end
  
  it { should.respond_to?(:email )}
  it { should.respond_to?(:jwt )}
  
  it "Devise should be remote Authenticatable" do
    Customer.include?(Devise::Models::RemoteAuthenticatable).should be true
  end
  
  describe "valid_auth_token?" do
    before(:each) do
      payload1 = {data: 'test@gmail.com'}
      token1 = JWT.encode payload1, nil, 'none'
      @c1 = Customer.new(jwt: token1)
      @decoded_token1 = [{"data"=>"test@gmail.com"}, {"typ"=>"JWT", "alg"=>"none"}]
      payload2 = {data: 'test@gmail.com', exp: Time.now - 1.hours}
      token2 = JWT.encode payload2, nil, 'none'
      @c2 = Customer.new(jwt: token2)
      @c3 = Customer.new
    end
    context "jwt is present" do
      it "should return true if token is valid and not expired" do
        @c1.valid_auth_token?.should eq @decoded_token1
      end
      it "should return fasle if token is invalid and expired" do
        @c2.valid_auth_token?.should be false
      end
    end
    context "jwt is not present" do
      it "should return nil" do
        @c3.valid_auth_token?.should be nil
      end
    end
  end
  
  describe "populate_attributes" do
    context "user with valid auth token" do
      it "should populates user attributes" do
        stub_auth_api_request('test@gmail.com', 'test123', { "jwt": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE0OTQyMjIxMTAsImF1ZCI6ZmFsc2UsInN1YiI6ImN1c3RvbWVyXzU5In0.8PjEL9nyWtHbJ9X5lt-r1ZXQT5_Y7Y0oClnA8xaSyAs"}, 201 )
        customer = Customer.authenticate!('test@gmail.com', 'test123')
        stub_verified_api_request(customer.jwt, veified_return_body , 201)
        customer = customer.populate_attributes
        customer[:email].should eq "test@gmail.com"
        customer[:phone_number].should eq "+111111111"
      end
    end
    context "user with invalid auth token" do
      it "should retutrn nil" do
        customer = Customer.new
        stub_verified_api_request(customer.jwt, nil , 401)
        customer = customer.populate_attributes
        customer.should be nil
      end
    end
  end
   
  describe "self.authenticate!(email, password)" do
    context "user with valid credentials" do
      it "should authenticate user" do
        stub_auth_api_request('test@gmail.com', 'test123', { "jwt": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE0OTQyMjIxMTAsImF1ZCI6ZmFsc2UsInN1YiI6ImN1c3RvbWVyXzU5In0.8PjEL9nyWtHbJ9X5lt-r1ZXQT5_Y7Y0oClnA8xaSyAs"}, 201 )
        Customer.authenticate!('test@gmail.com', 'test123').should be_instance_of Customer
      end
    end
    context "user with invalid credentials" do
      it "should not authenticate user" do
        stub_auth_api_request('invalid@gmail.com', '123456', {}, 401 )
        Customer.authenticate!('invalid@gmail.com', '123456').should be nil
      end
    end
  end 
  

end

