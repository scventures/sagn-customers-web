class ServiceRequests::ServiceRequestAssignmentsController < ApplicationController
  before_action :authenticate_customer!, :set_account

  def start_accepting
    find_service_request_and_assignment
    if @assignment.responded?
      @assignment.start_accepting
    end
    respond_to do |format|
      format.js
    end
  end

  def payment_authorize
    token = params['service_request']['token'] if params['service_request']
    find_service_request_and_assignment
    if @assignment.accept(token)
      @service_request = @account.service_requests.find(params[:service_request_id])
      @activities = @service_request.activities
    end
    respond_to do |format|
      format.js
    end
  end
  
  def start_declining
    find_service_request_and_assignment
    respond_to do |format|
      format.js
    end
  end
  
  def decline
    find_service_request_and_assignment
    if @decline_assignment = @assignment.decline(params[:assignment][:reason])
      @activities = @service_request.activities
    end
    respond_to do |format|
      format.js
    end
  end
  
  def start_accepting_estimation
    find_service_request_and_assignment
    @start_accepting_estimation = @assignment.start_accepting_estimation
    respond_to do |format|
      format.js
    end
  end
  
  def accept_estimation
    token = params[:service_request][:token] if params[:service_request]
    @assignment = Assignment.find(params[:service_request_assignment_id], _account_id: @account.id, _service_request_id: params[:service_request_id])
    @assignment.account_id = @account.id
    @assignment.service_request_id = params[:service_request_id].to_i
    if @assignment[:current_estimation][:status] != 'accepted'
      if @accept_estimation = @assignment.accept_estimation(params[:token])
        @service_request = @account.service_requests.find(params[:service_request_id])
        @service_request.account_id = @account.id
        @assignments = @service_request.assignments
        @activities = @service_request.activities
      end
    end
    respond_to do |format|
      format.js
    end
  end
  
  def start_declining_estimation
    find_service_request_and_assignment
    @estimation = Estimation.new
    respond_to do |format|
      format.js
    end
  end
  
  def decline_estimation
    reason =  params[:estimation][:reason]
    find_service_request_and_assignment
    if @decline_estimation = @assignment.decline_estimation(reason)
      @activities = @service_request.activities
    end
    respond_to do |format|
      format.js
    end
  end
  
  def consider_estimation
    find_service_request_and_assignment
    @consider_estimation = @assignment.consider_estimation
    respond_to do |format|
      format.js
    end
  end
  
  private
  
  def set_account
    @account = current_customer.current_account
  end
  
  def find_service_request_and_assignment
    @service_request = @account.service_requests.find(params[:service_request_id])
    @service_request.account_id = @account.id
    @assignment = @service_request.assignments.find(params[:service_request_assignment_id])
    @assignment.account_id = @account.id
    @assignment.service_request_id = @service_request.id
  end
  
end
