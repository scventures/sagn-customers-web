class ServiceRequestsController < ApplicationController

  before_action :authenticate_customer!
  
  def new
    current_customer.populate_attributes
    @locations = current_customer.current_account.locations
    @service_request = ServiceRequest.new
  end
  
  def create
  
  end
  
end
