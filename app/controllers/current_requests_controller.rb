class CurrentRequestsController < ApplicationController

  before_action :authenticate_customer!
  
  def index
    @account = current_customer.current_account
    @current_requests = @account.current_service_requests
    unless @current_requests.length.zero?
      @current_request = ServiceRequest.find(@current_requests.first.id, _account_id: @account.id)
      @current_request.account_id = @account.id
      @activities = @current_request.activities
      @assignments = @current_request.assignments if @current_request.assigned?
    end
  end
  
  def show
    @account = current_customer.current_account
    @service_request = @account.service_requests.find(params[:id])
    @service_request.account_id = @account.id
    @activities = @service_request.activities
    @assignments = @service_request.assignments if @service_request.assigned?
    respond_to do |format|
      format.js {}
    end
  end
  
  def cancel
    account = current_customer.current_account
    service_request = account.service_requests.build(id: params[:current_request_id], _account_id: account.id)
    if service_request.cancel
      redirect_to current_requests_path, notice: "Service Request ##{service_request.id} has been cancelled."
    else
      redirect_to current_requests_path, alert: service_request.errors.full_messages.join(', ')
    end
  end
  
end
