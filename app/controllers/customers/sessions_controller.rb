class Customers::SessionsController < Devise::SessionsController

  def create_service_request_with_login
    customer = Customer.new sign_in_with_service_request_params
    if customer.authenticate!
      bypass_sign_in(customer)
      if customer.create_service_request
        redirect_to after_sign_in_path_for(customer), notice: 'Service Request created successfully.'
      else
        redirect_to after_sign_in_path_for(customer), alert: 'Unable to create Service Request. Please try again'
      end
    else
      @categories = Category.all.fetch.group_by(&:parent_category_id)
      customer.location = Location.new unless customer.location?
      customer.service_request = ServiceRequest.new unless customer.service_request?
      customer.service_request.issue_images = Her::Collection.new
      respond_to do |format|
        format.js
      end
    end
  end

  private
  
  def sign_in_with_service_request_params
    params.require(:customer).permit(:email, :password, service_request_attributes: [:location_id, :brand_name, :brand_id, :model, :serial, :urgent, :work_time_details, :problem_code_id, :equipment_item_id, :problem, :category_id, :subcategory_id, :token, :phone_number, :notes, :contact_details, issue_images_attributes: [:image, :id]], location_attributes: [ :name, :address_1, :address_2, :address_3, :city, :state, :zip, :phone_number, { geography: [:latitude, :longitude]}]).to_h
  end
  
  def after_sign_in_path_for(resource_or_scope)
    stored_location_for(resource_or_scope) || dashboard_path
  end
end
