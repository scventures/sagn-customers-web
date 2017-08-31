class CustomersController < ApplicationController
  before_action :authenticate_customer!, except: :new
  layout 'devise', only: :new
  
  def new
    @customer = Customer.new
    @location = Location.new
    @service_request = ServiceRequest.new
    @categories = Category.where(q: {core_category_true: 1}).group_by(&:parent_category_id)
    @service_request.issue_images = Her::Collection.new
  end

  def resend_email_confirmation
    Customer.send_confirmation_instructions(email: current_customer.email)
    respond_to do |format|
      format.js
    end
  end

  def resend_mobile_confirmation
  
  end
  
  def verify_customer
    render json: { verified: current_customer.registered? }
  end

  def layer_identity
    render json: {token: current_customer.get_layer_identity_token(params[:nonce])}
  end

end
