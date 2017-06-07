class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :render_getapps
  before_action :set_customer_api_token

  protected

  def render_getapps
    render 'shared/getapps', layout: 'mobile' and return if browser.platform.android? or browser.platform.ios?
  end
  
  def set_customer_api_token
    if current_customer
      RequestStore.store[:auth_token] = current_customer.jwt
      begin
        current_customer.populate_attributes
        RequestStore.store[:current_customer] = current_customer
      rescue
        force_log_out
      end
    end
  end
  
  def force_log_out
    cookies.delete '_sagn-customers-web_session'
  end

end
