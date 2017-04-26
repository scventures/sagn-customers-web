class ServiceRequests::ServiceRequestAssignmentsController < ApplicationController

  def start_accepting
    @account = current_customer.current_account
    @service_request = @account.service_requests.find(params[:service_request_id])
    @service_request.account_id = @account.id
    @assignment = @service_request.assignments.find(params[:service_request_assignment_id])
    @assignment.account_id = @account.id
    @assignment.service_request_id = @service_request.id
    if @assignment.responded?
      @assignment.start_accepting
    end
    respond_to do |format|
      format.js
    end
  end

  def payment_authorize
    token = params['service_request']['token']
    @account = current_customer.current_account
    @service_request = @account.service_requests.find(params[:service_request_id])
    @service_request.account_id = @account.id
    @assignment = @service_request.assignments.find(params[:service_request_assignment_id])
    @assignment.account_id = @account.id
    @assignment.service_request_id = @service_request.id
    @assignment.accept(token)
    respond_to do |format|
      format.js
    end
  end

end
