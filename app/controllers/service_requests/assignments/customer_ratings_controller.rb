class ServiceRequests::Assignments::CustomerRatingsController < ApplicationController
  
  def create
    @account = current_customer.current_account
    @service_request = @account.service_requests.find(params[:service_request_id])
    @service_request.account_id = @account.id
    @assignment = @service_request.assignments.find(params[:assignment_id])
    @customer_rating = @assignment.customer_ratings.build(customer_rating_params)
    @customer_rating.attributes = { account_id: @account.id, service_request_id: @service_request.id}
    respond_to do |format|
      if @customer_rating.save
        format.js
      else
        format.js { render partial: 'past_requests/customer_rating_form', locals: { customer_rating: @customer_rating, service_request: @service_request, assignment: @assignment }, replace: '#customer_rating_form' }
      end
    end
  end
  
  private

  def customer_rating_params
    params.permit(customer_rating: [:stars, :comment]).to_h
  end

end
