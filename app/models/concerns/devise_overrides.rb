module DeviseOverrides
  extend ActiveSupport::Concern

  def confirmed?
    active?
  end

  def confirmation_required?
    false
  end

  def send_confirmation_instructions
    confirmable_value = pending_reconfirmation? ? unconfirmed_email : email
    errors.add(email, :blank) and return if confirmable_value.blank?
    params = {
      customer: {
        email: confirmable_value,
        redirect_url: "#{APP_URL}/confirmation"
      }
    }
    Customer.post_raw('customers/confirmation', params) do |parsed_data, response|
      populate_errors(parsed_data[:errors]) if response.status == 422
    end
  end
  
  def authenticate!
    customer = Customer.authenticate!(email, password)
    self.jwt = customer.jwt if customer
  end

  module ClassMethods
    def send_reset_password_instructions(attributes={})
      customer = Customer.new(attributes)
      customer.errors.add(:email, :blank) and return customer unless customer.email?
      params = {customer: {email: customer.email, redirect_url: "#{APP_URL}/password/edit"}}
      Customer.post_raw('customers/password', params) do |parsed_data, response|
        if response.status == 422
          parsed_data[:errors].each do |k, v|
            customer.errors.add(k, v.first)
          end
        end
      end
      customer
    end

    def reset_password_by_token(attributes={})
      customer = Customer.new(attributes)
      customer.valid?
      return customer if [:password, :password_confirmation].any? {|k| customer.errors.has_key? k}
      customer.errors.clear
      params = {
        customer: {
          reset_password_token: customer.reset_password_token,
          password: customer.password,
          password_confirmation: customer.password_confirmation
        }
      }
      Customer.put_raw('customers/password', params) do |parsed_data, response|
        if response.status == 422
          parsed_data[:errors].each do |k, v|
            customer.errors.add(k, v.first)
          end
        end
      end
      customer
    end

    def confirm_by_token(confirmation_token)
      customer = Customer.new(confirmation_token: confirmation_token)
      Customer.get_raw('customers/confirmation', {confirmation_token: customer.confirmation_token}) do |parsed_data, response|
        if response.status == 422
          parsed_data[:errors].each do |k, v|
            customer.errors.add(k, v.first)
          end
        end
      end
      customer
    end

    def send_confirmation_instructions(attributes={})
      customer = Customer.new(attributes)
      customer.resend_confirmation_instructions
      customer
    end

    def authenticate!(email, password)
      customer = Customer.new(email: email, password: password)
      post_raw('customers/auth_token', auth: {email: customer.email, password: customer.password}) do |parsed_data, response|
        customer.jwt = parsed_data[:data][:jwt] if response.status == 201
      end
      return nil unless customer.valid_auth_token?
      RequestStore.store[:auth_token] = customer.jwt
      customer
    end
  end

  def self.prepended(base)
    class << base
      prepend ClassMethods
    end
  end

end
