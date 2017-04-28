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
      if resource.create_service_request
        redirect_to profile_path, notice: 'Service Request created successfully.'
      else
        redirect_to profile_path, alert: 'Unable to create Service Request. Please try again'
      end
    else
      @categories = Category.all.fetch.group_by(&:parent_category_id)
      @customer.location = Location.new unless @customer.location?
      @customer.service_request = ServiceRequest.new unless @customer.service_request?
      respond_to do |format|
        format.js { render partial: 'customers/form', locals: { customer: resource, categories: @categories }, within: ".service-request-form-wrapper"}
      end
    end
  end
  
  protected

  def sign_up_params
    params.require(:customer).permit(
      :name, :customer_account_name, :email, :unconfirmed_phone, :password, :password_confirmation, :tos_accepted, service_request_attributes: [:location_id, :equipment_id, :brand_name, :brand_id, :model, :serial, :urgent, :work_time_details,
      :problem, :category_id, :subcategory_id, :token, :full_name, :email, :phone_number, :company_name, :notes], location_attributes: [ :name, :address_1, :address_2, :address_3, :city, :state, :zip, :phone_number, {:geography => [:latitude, :longitude]}] )
  end
  
  def build_resource(hash=nil)
    super
    resource.redirect_url = customer_confirmation_url
    resource.define_singleton_method(:request_path) {'customers/registration'}
    resource
  end
  
end
