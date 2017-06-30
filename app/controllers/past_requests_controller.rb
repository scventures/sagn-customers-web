class PastRequestsController < ApplicationController

  before_action :authenticate_customer!
  
  def index
    @account = current_customer.current_account
    @past_requests = @account.past_service_requests
    @current_requests = @account.current_service_requests.select {|c| !c.is_active or ['cancelled', 'final_bill_sent', 'completed', 'customer_declined_estimation'].include?(c.latest_activity_status_raw) }
    @past_requests += @current_requests
    @past_requests = @past_requests.sort_by(&:created_at).reverse
    unless @past_requests.length.zero?
      @service_request = @account.service_requests.find(@past_requests.first.id)
      @service_request.account_id = @account.id
      @activities = @service_request.activities
      if @service_request.responded_request_assignment_id
        @assignment = @service_request.assignments.find(@service_request.responded_request_assignment_id)
        @customer_rating = @assignment.customer_ratings.build()
      end
    end
  end
  
  def show
    @account = current_customer.current_account
    @service_request = @account.service_requests.find(params[:id])
    @service_request.account_id = @account.id
    @activities = @service_request.activities
    if @service_request.responded_request_assignment_id
      @assignment = @service_request.assignments.find(@service_request.responded_request_assignment_id)
      @customer_rating = @assignment.customer_ratings.build()
    end
    respond_to do |format|
      format.js {}
    end
  end
  
end
