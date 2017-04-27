class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_customer_api_token

  def sign_in(resource)
    resource.authenticate! unless resource.jwt?
    bypass_sign_in(resource)
  end

  protected
  def set_customer_api_token
    if current_customer
      RequestStore.store[:auth_token] = current_customer.jwt
      current_customer.populate_attributes
      RequestStore.store[:current_customer] = current_customer
    end
  end

end
