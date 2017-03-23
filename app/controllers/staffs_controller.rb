class StaffsController < ApplicationController

  before_action :authenticate_customer!
  
  def index
    @staffs = Staff.all(_account_id: current_customer.current_account_id).fetch
  end

  def new
    @staff = Staff.new
  end
  
  def create
    @staff = Staff.new(staff_params.to_h.merge(account_id: current_customer.current_account_id))
    if @staff.save
      redirect_to staffs_path
    else
      respond_to do |format|
        format.js { render partial: "staffs/form", locals: { staff: @staff }, replace: ".staff-form-container" }
      end
    end
  end
  
  def destroy
    @staff = Staff.new(id: params[:id], account_id: current_customer.current_account_id)
    if @staff.destroy
      redirect_to staffs_path, notice: 'Staff deleted successfully'
    else
      redirect_to staffs_path, alert: @staff.errors.full_messages.join(', ')
    end
  end
  
  private
  
  def staff_params
    params.required(:staff).permit(:name, :email).to_h
  end

end
