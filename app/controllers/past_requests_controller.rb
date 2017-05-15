class PastRequestsController < ApplicationController

  before_action :authenticate_customer!
  
  def index
    @past_requests = current_customer.current_account.past_service_requests
  end
  
  def show
    @account = current_customer.current_account
    @service_request = @account.service_requests.find(params[:id])
    @service_request.account_id = @account.id
    @activities = @service_request.activities
    @assignment = @service_request.assignments.find(@service_request.responded_request_assignment_id)
    @customer_rating = @assignment.customer_ratings.build() 
    respond_to do |format|
      format.js {}
    end
  end
  
end
