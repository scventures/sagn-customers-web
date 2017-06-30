class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  rescue_from Warden::NotAuthenticated, with: :force_log_out
  rescue_from Faraday::Error::ConnectionFailed, with: :bad_connection
  
  before_action :render_getapps
  before_action :set_customer_api_token
  before_filter :check_for_registration, except: [:bad_connection, :force_log_out]

  protected

  def render_getapps
    render 'shared/getapps', layout: 'mobile' and return if browser.platform.android? or browser.platform.ios?
  end

  def check_for_registration
    if current_customer
      unless current_customer.registered?
        redirect_to profile_path
      end
    end
  end
  
  def set_customer_api_token
    if current_customer
      RequestStore.store[:auth_token] = current_customer.jwt
      current_customer.populate_attributes
      RequestStore.store[:current_customer] = current_customer
    end
  end
  
  def force_log_out
    sign_out current_customer
    redirect_to root_path, alert: 'You need to sign in or sign up before continuing.'
  end
  
  def bad_connection
    render 'shared/bad_connection', layout: 'bad_connection' and return
  end

end
