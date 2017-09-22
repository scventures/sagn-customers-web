class Customers::PasswordsController < Devise::PasswordsController
  skip_before_action :render_getapps, only: [:edit, :update]
  layout :password_layout
  
  protected
  
  def password_layout
    if browser.platform.android? or browser.platform.ios?
      'mobile'
    else
      'application'
    end
  end

  def after_resetting_password_path_for(resource)
    new_customer_session_path
  end
  
end
