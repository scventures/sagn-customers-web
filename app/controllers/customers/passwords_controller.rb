class Customers::PasswordsController < Devise::PasswordsController

  protected

  def after_resetting_password_path_for(resource)
    new_customer_session_path
  end

end
