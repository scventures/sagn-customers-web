class Customers::SessionsController < Devise::SessionsController
  skip_before_filter :check_for_registration, :only => [:destroy]
  def create_service_request_with_login
    customer = Customer.new sign_in_with_service_request_params
    if customer.authenticate!
      bypass_sign_in(customer)
      if customer.create_service_request
        flash[:alert] = "To receive push notification regarding the service request you must confirm your phone number and email. #{view_context.link_to('Click here to confirm.', profile_path)}".html_safe unless customer.active
        flash[:notice] = 'Service Request created successfully.'
        redirect_to current_requests_path
      else
        if customer.service_request.location_id
          redirect_to new_location_service_request_path(customer.service_request.location_id, service_request: customer.service_request.attributes), alert: 'Unable to create service request. Please try again.'
        else
          redirect_to service_requests_path, alert: customer.location.errors.full_messages.join(',')
        end
      end
    else
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
    stored_location_for(resource_or_scope) || service_requests_path
  end
end
