class Customer
  include Her::Model
  extend Devise::Models

  attributes :email, :jwt

  devise :remote_authenticatable

  def valid_auth_token?
    if jwt.present?
      begin
        token = JWT.decode jwt, nil, false
      rescue JWT::ExpiredSignature
        false
      end
    end
  end

  def populate_attributes
    c = Customer.get(:viewer)
    self.attributes = c.customer
  end

  def self.authenticate!(email, password)
    customer = post(:auth_token, auth: {email: email, password: password})
    customer.valid_auth_token? ? customer : nil
  end


end
