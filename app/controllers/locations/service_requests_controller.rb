class Locations::ServiceRequestsController < ApplicationController

  before_action :authenticate_customer!
  
  def new
    @categories = Category.all.fetch.group_by(&:parent_category_id)
    @current_account = current_customer.current_account
    @contractors = @current_account.contractors
    @location = @current_account.locations.find(params[:location_id])
    @service_request = @location.service_requests.build()
    @service_request.issue_images = Her::Collection.new
  end
  
  def create
    @service_request = ServiceRequest.new(service_request_params.to_h.merge(account_id: current_customer.current_account_id))
    if @service_request.save
      redirect_to service_request_path(@service_request)
    else
      @categories = Category.all.fetch.group_by(&:parent_category_id)
      @current_account = current_customer.current_account
      @location = @current_account.locations.find(@service_request.location_id)
      @contractors = @current_account.contractors
      @service_request.issue_images = Her::Collection.new
      respond_to do |format|
        format.js { render partial: "locations/service_requests/form", locals: { service_request: @service_request, location: @location, categories: @categories }, replace: ".place-request-service-form-container" }
      end
    end
  end
  
  private
  
  def service_request_params
    permitted_params = params.required(:service_request).permit(
      :location_id, :equipment_id, :brand_name, :model, :serial, :urgent, :work_time_details, :select_guy,
      :problem, :category_id, :subcategory_id, :token, :full_name, :email, :phone_number, :company_name, issue_images_attributes: [:image]
    ).to_h
    permitted_params.merge(location_id: params[:location_id])
  end
  
end
