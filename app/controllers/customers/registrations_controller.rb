class Customers::RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(sign_up_params)
    if resource.save
      set_flash_message! :notice, :signed_up_but_unconfirmed
      expire_data_after_sign_in!
      respond_with resource, location: after_inactive_sign_up_path_for(resource)
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end
  
  def create_with_service_request
    build_resource(sign_up_params)
    if resource.save
      resource.authenticate!
      bypass_sign_in(resource)
      resource.create_service_request
      redirect_to profile_path, alert: 'Complete Your Registration'
    else
      respond_to do |format|
        format.js { render json: resource.errors, status: :unprocessable_entity, root: false }
      end
    end
  end
  
  protected

  def sign_up_params
    params.require(:customer).permit(
      :name, :customer_account_name, :email, :unconfirmed_phone, :password, :password_confirmation, :tos_accepted, service_request_attributes: [:location_id, :brand_name, :brand_id, :model, :serial, :urgent, :work_time_details, :problem_code_id, :equipment_item_id,
      :problem, :category_id, :token, :phone_number, :notes, :contact_details, issue_images_attributes: [:image, :id]], location_attributes: [ :name, :address_1, :address_2, :address_3, :city, :state, :zip, :phone_number, { geography: [:latitude, :longitude]}]).to_h
  end
  
  def build_resource(hash=nil)
    super
    resource.redirect_url = customer_confirmation_url
    resource.define_singleton_method(:request_path) {'customers/registration'}
    resource
  end
  
end
