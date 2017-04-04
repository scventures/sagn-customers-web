class StaffController < ApplicationController

  before_action :authenticate_customer!
  
  def index
    @staff = current_customer.current_account.staff
    @registered_staff = @staff.select{|s| s.customer[:active] == true }
    @invited_staff = @staff.select{|s| s.customer[:active] == false }
  end

  def new
    @account = current_customer.current_account
    @account.staff = [@account.staff.build]
    respond_to do |format|
      format.js {}
    end
  end
  
  def create_multiple
    @account = current_customer.current_account
    @account.assign_attributes account_params
    staff_with_errors = []
    @account.staff.each do |staff|
      staff.account_id = @account.id #TODO: remove once released https://github.com/remiprev/her/pull/318
      unless staff.save
        staff_with_errors << staff
      end
    end
    if staff_with_errors.empty?
      redirect_to staff_index_path, notice: 'Staff added successfully'
    else
      @account.staff = staff_with_errors
      respond_to do |format|
        format.js { render partial: 'staff/form', locals: { account: @account }, replace: '.my-staff-form-wrapper' }
      end
    end
  end
  
  def destroy
    @staff = current_customer.current_account.staff.build(id: params[:id])
    if @staff.destroy
      redirect_to staff_index_path, notice: 'Staff deleted successfully'
    else
      redirect_to staff_index_path, alert: @staff.errors.full_messages.join(', ')
    end
  end
  
  private
  
  def staff_params
    params.required(:staff).permit(:name, :email).to_h
  end
  
  def account_params
    params.required(:account).permit(staff_attributes: [:name, :email, :first_name, :last_name, :_destroy]).to_h
  end

end
