class CurrentRequestsController < ApplicationController

  before_action :authenticate_customer!
  
  def index
    @account = current_customer.current_account
    @current_requests = @account.current_requests
    if @current_requests.present?
      current_request_id = flash[:service_request_id] ? flash[:service_request_id] : @current_requests.first.id
      @service_request= ServiceRequest.find(current_request_id, _account_id: @account.id)
      @service_request.account_id = @account.id
      @current_assignment = @service_request.current_assignment if @service_request.responded_request_assignment_id
      @activities = @service_request.activities
    end
    response.set_header('SERVICE_REQUEST_ID', flash[:service_request_id]) if flash[:service_request_id]
  end
  
  def show
    @account = current_customer.current_account
    @service_request = @account.service_requests.find(params[:id])
    @service_request.account_id = @account.id
    @current_assignment = @service_request.current_assignment if @service_request.responded_request_assignment_id
    @activities = @service_request.activities
    if request.xhr?
      render partial: 'show', locals: { service_request: @service_request, activities: @activities, current_assignment: @current_assignment }, layout: false
    else
      @current_requests = @account.current_requests
      render 'index'
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
