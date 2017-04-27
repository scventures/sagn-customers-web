class ServiceRequestsController < ApplicationController

  before_action :authenticate_customer!
  
  def index
    @current_account = current_customer.current_account
    @locations = @current_account.locations
  end
  
end
