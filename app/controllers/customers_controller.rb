class CustomersController < ApplicationController
  before_action :authenticate_customer!

  def resend_email_confirmation
    Customer.send_confirmation_instructions(email: current_customer.email)
    respond_to do |format|
      format.js
    end
  end

  def resend_mobile_confirmation
  
  end

end
