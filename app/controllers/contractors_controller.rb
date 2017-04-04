class ContractorsController < ApplicationController

  before_action :authenticate_customer!

  def new
    @account = current_customer.current_account
    @account.contractors = [@account.contractors.build]
    respond_to do |format|
      format.js {}
    end
  end

  def index
    contractors = current_customer.current_account.contractors
    @registered_contractors = contractors.select{ |c| c.status== 'active'}
    @invited_contractors = contractors.select{ |c| c.status == 'invited' or c.status == 'pending' }
  end

  def create_multiple
    @account = current_customer.current_account
    @account.assign_attributes account_params
    contractors_with_errors = []
    @account.contractors.each do |contractor|
      contractor.account_id = @account.id #TODO: remove once released https://github.com/remiprev/her/pull/318
      unless contractor.save
        contractors_with_errors << contractor
      end
    end
    if contractors_with_errors.empty?
      redirect_to contractors_path, notice: 'Contractors added successfully'
    else
      @account.contractors = contractors_with_errors
      respond_to do |format|
        format.js { render partial: 'contractors/form', locals: { account: @account }, replace: '.my-guys-form-wrapper' }
      end
    end
  end

  def destroy
    @contractor = current_customer.current_account.contractors.build(id: params[:id])
    if @contractor.destroy
      redirect_to contractors_path, notice: 'Contractor deleted successfully'
    else
      redirect_to contractors_path, alert: @contractor.errors.full_messages.join(', ')
    end
  end

  private

  def account_params
    params.required(:account).permit( contractors_attributes: [ :email, :contact_name, :business_name, :phone_number, :_destroy]).to_h
  end

end
