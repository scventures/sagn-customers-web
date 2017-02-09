class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_customer_api_token

  protected
  def set_customer_api_token
    RequestStore.store[:auth_token] = current_customer.jwt if current_customer
  end

end
