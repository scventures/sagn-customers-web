class Customers::RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(sign_up_params)
    if resource.save
      if params[:service_request]
        sign_in(resource)
        if resource.create_service_request(params[:location], params[:service_request])
          redirect_to profile_path, notice: 'Service Request created successfully.'
        else
          redirect_to profile_path, alert: 'Unable to create Service Request. Please try again'
        end 
      else
        set_flash_message! :notice, :signed_up_but_unconfirmed
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end
  
  protected

  def sign_up_params
    params.require(:customer).permit(
      :name, :customer_account_name, :email, :unconfirmed_phone, :password, :password_confirmation, :tos_accepted)
  end
  
  def build_resource(hash=nil)
    super
    resource.redirect_url = customer_confirmation_url
    resource.define_singleton_method(:request_path) {'customers/registration'}
    resource
  end
  
end





