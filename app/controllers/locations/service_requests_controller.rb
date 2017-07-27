class Locations::ServiceRequestsController < ApplicationController

  before_action :authenticate_customer!, :check_customer_registration_status
  
  def new
    @categories = Category.all.fetch.group_by(&:parent_category_id)
    @current_account = current_customer.current_account
    @contractors = @current_account.contractors
    @location = @current_account.locations.find(params[:location_id])
    @service_request = @location.service_requests.build()
    @service_request.attributes = service_request_params
    @service_request.issue_images = Her::Collection.new
  end
  
  def create
    @service_request = ServiceRequest.new(service_request_params.to_h.merge(account_id: current_customer.current_account_id))
    if @service_request.save
      redirect_to current_requests_path, flash: {service_request_id: @service_request.id}
    else
      @categories = Category.all.fetch.group_by(&:parent_category_id)
      @current_account = current_customer.current_account
      @location = @current_account.locations.find(@service_request.location_id)
      @contractors = @current_account.contractors
      @service_request.issue_images = Her::Collection.new
      render 'locations/create_with_service_request' and return
    end
  end
  
  def edit
    @account = current_customer.current_account
    @service_request = @account.service_requests.find(params[:id])
    @service_request.account_id = @account.id
    @categories = Category.all.fetch.group_by(&:parent_category_id)
    @location = @account.locations.find(@service_request.location[:id])
    respond_to do |format|
      format.js
    end
  end

  def update
    @account = current_customer.current_account
    service_request = @account.service_requests.find(params[:id])
    service_request.account_id = @account.id
    @service_request = ServiceRequest.save_existing(service_request.id, service_request_params.to_h.merge(account_id: @account.id, id: service_request.id))
    respond_to do |format|
      format.js
    end
  end

  private
  
  def service_request_params
    permitted_params = params.required(:service_request).permit(
      :location_id, :brand_name, :brand_id, :model, :serial, :urgent, :work_time_details, :select_guy,
      :problem, :category_id, :subcategory_id, :problem_code_id, :equipment_item_id, :token, :phone_number, :notes, :contact_details, issue_images_attributes: [:image]
    ).to_h
    permitted_params.merge(location_id: params[:location_id])
  end
  
  def check_customer_registration_status
    redirect_to profile_path, alert: 'Complete Registration.' unless current_customer.active
  end

end
