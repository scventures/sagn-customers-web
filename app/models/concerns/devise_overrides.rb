module DeviseOverrides
  extend ActiveSupport::Concern

  def confirmed?
    active?
  end

  def confirmation_required?
    false
  end

  def password_required?
    !password.nil? || !password_confirmation.nil?
  end

  module ClassMethods
    def send_reset_password_instructions(attributes={})
      customer = Customer.new(attributes)
      customer.errors.add(:email, :blank) and return customer unless customer.email?
      params = {customer: {email: customer.email, redirect_url: "#{ENV['APP_URL']}/password/edit"}}
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
      customer.errors.add(:email, :blank) and return customer unless customer.email?
      params = {
        customer: {
          email: customer.email,
          redirect_url: "#{ENV['APP_URL']}/confirmation"
        }
      }
      Customer.post_raw('customers/confirmation', params) do |parsed_data, response|
        customer.populate_errors(parsed_data[:errors]) if response.status == 422
      end
      customer
    end

    def authenticate!(email, password)
      customer = Customer.new(email: email, password: password)
      post_raw('customers/auth_token', auth: {email: customer.email, password: customer.password}) do |parsed_data, response|
        customer.jwt = parsed_data[:data][:jwt] if response.status == 201
      end
      customer.valid_auth_token? ? customer : nil
    end
  end

end
