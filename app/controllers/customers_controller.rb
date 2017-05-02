class CustomersController < ApplicationController
  before_action :authenticate_customer!, except: :new
  layout 'devise', only: :new
  
  def new
    @customer = Customer.new
    @customer.location = Location.new
    @customer.service_request = ServiceRequest.new
    @categories = Category.all.fetch.group_by(&:parent_category_id)
  end

  def resend_email_confirmation
    Customer.send_confirmation_instructions(email: current_customer.email)
    respond_to do |format|
      format.js
    end
  end

  def resend_mobile_confirmation
  
  end

end
