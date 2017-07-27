class Customers::SessionsController < Devise::SessionsController
  skip_before_filter :check_for_registration, :only => [:destroy]
  def create_service_request_with_login
    customer = Customer.new sign_in_with_service_request_params
    if customer.authenticate!
      bypass_sign_in(customer)
      redirect_to after_sign_in_path_for(customer)
    else
      respond_to do |format|
        format.js
      end
    end
  end

  private
  
  def sign_in_with_service_request_params
    params.require(:customer).permit(:email, :password).to_h
  end
  
  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || service_requests_path
  end
end
