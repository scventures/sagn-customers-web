class Customer
  include Her::Model
  extend Devise::Models

  attributes :email, :jwt, :password, :password_confirmation

  devise :remote_authenticatable, :recoverable

  validates_presence_of     :password, if: :password_required?
  validates_confirmation_of :password, if: :password_required?

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

  def self.send_reset_password_instructions(attributes={})
    customer = Customer.new(attributes)
    customer.errors.add(:email, :blank) and return customer unless customer.email?
    params = {customer: {email: customer.email, redirect_url: "#{Rails.application.secrets.host}/password/edit"}}
    Customer.post_raw('customers/password', params) do |parsed_data, response|
      if response.status == 422
        parsed_data[:data].each do |k, v|
          customer.errors.add(k, v.first)
        end
      end
    end
    customer
  end

  def self.reset_password_by_token(attributes={})
    customer = Customer.new(attributes)
    return customer unless customer.valid?
    params = {
      customer: {
        reset_password_token: customer.reset_password_token,
        password: customer.password,
        password_confirmation: customer.password_confirmation
      }
    }
    Customer.put_raw('customers/password', params) do |parsed_data, response|
      if response.status == 422
        parsed_data[:data].each do |k, v|
          customer.errors.add(k, v.first)
        end
      end
    end
    customer
  end

  def password_required?
    !password.nil? || !password_confirmation.nil?
  end

  def self.authenticate!(email, password)
    customer = post(:auth_token, auth: {email: email, password: password})
    customer.valid_auth_token? ? customer : nil
  end

end
