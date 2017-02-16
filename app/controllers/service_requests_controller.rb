class ServiceRequestsController < ApplicationController

  before_action :authenticate_customer!
  
  def new
    current_customer.populate_attributes
    @categories = current_customer.categories
    @locations = current_customer.current_account.locations
    @service_request = ServiceRequest.new
    @service_request.issue_images = Her::Collection.new
  end
  
  def create
    current_customer.populate_attributes
    @service_request = ServiceRequest.new(service_request_params.to_h.merge(account_id: current_customer.current_account_id))
    if @service_request.save
      redirect_to dashboard_path
    else
      @categories = current_customer.categories
      @locations = current_customer.current_account.locations
      render 'new'
    end
  end
  
  private
  
  def service_request_params
    params.required(:service_request).permit(
      :location_id, :equipment_id, :brand_name, :model, :serial, :urgent, 
      :problem, :category_id, :subcategory_id, issue_images_attributes: [:image]
    ).to_h
  end
  
end
