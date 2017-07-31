class ProfilesController < ApplicationController
  before_action :authenticate_customer!
  skip_before_filter :check_for_registration

  def show
    flash[:alert] = nil
  end

  def edit
    @customer = current_customer
    @customer.unconfirmed_phone = @customer.phone_number.presence || @customer.unconfirmed_phone
  end

  def update
    @customer = Customer.save_existing(current_customer.id, permitted_params)
    if @customer.errors.any?
      respond_to do |format|
        format.js {render partial: 'form', locals: {customer: @customer}, replace: "form#edit_customer_#{@customer.id}"}
      end
    else
      redirect_to profile_path, notice: 'Profile updated successfully.'
    end
  end

  def resend_email_confirmation
    current_customer.resend_confirmation_instructions
    respond_to do |format|
      format.js
    end
  end

  def resend_phone_confirmation
    current_customer.resend_phone_confirmation_instructions
    respond_to do |format|
      format.js
    end
  end

  def confirm_phone
    current_customer.assign_attributes(params.require(:customer).permit(:sms_confirmation_pin))
    if current_customer.verify_phone
      flash[:notice] = 'Phone number verified.'
      render 'profile_confirmation'
    else
      respond_to do |format|
        format.js {render partial: 'phone_confirmation_form', replace: 'form#confirm-phone'}
      end
    end
  end

  def change_password
    @customer = current_customer
    @customer.validate_current_password = true
  end

  def update_password
    @customer = current_customer
    @customer.attributes = password_params
    @customer.validate_current_password = true
    if @customer.update_password
      redirect_to profile_path, notice: 'Password updated successfully'
    else
      respond_to do |format|
        format.js {render partial: 'change_password_form', locals: {customer: @customer}, within: '#change-password-form-container'}
      end
    end
  end

  private
  def permitted_params
    params.require(:customer).permit(:name, :email, :unconfirmed_phone, :avatar)
  end

  def password_params
    params.require(:customer).permit(:current_password, :password, :password_confirmation)
  end

end
