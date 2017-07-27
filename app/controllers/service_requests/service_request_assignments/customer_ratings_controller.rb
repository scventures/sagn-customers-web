class ServiceRequests::ServiceRequestAssignments::CustomerRatingsController < ApplicationController
  
  def create
    @account = current_customer.current_account
    @service_request = @account.service_requests.find(params[:service_request_id])
    @service_request.account_id = @account.id
    @assignment = @service_request.assignments.find(params[:service_request_assignment_id])
    @customer_rating = @assignment.customer_ratings.build(customer_rating_params)
    @customer_rating.attributes = { account_id: @account.id, service_request_id: @service_request.id}
    @customer_rating.save
    respond_to do |format|
      format.js
    end
  end
  
  private

  def customer_rating_params
    params.required(:customer_rating).permit(:stars, :comment).to_h
  end

end
