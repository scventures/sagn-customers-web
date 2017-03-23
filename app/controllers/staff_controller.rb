class StaffController < ApplicationController

  before_action :authenticate_customer!
  
  def index
    @staff = current_customer.current_account.staff
  end

  def new
    @staff = Staff.new
  end
  
  def create
    @staff = Staff.new(staff_params.to_h.merge(account_id: current_customer.current_account_id))
    if @staff.save
      redirect_to staff_index_path
    else
      respond_to do |format|
        format.js { render partial: "staff/form", locals: { staff: @staff }, replace: ".staff-form-container" }
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

end
