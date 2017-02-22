class EquipmentItemsController < ApplicationController

  before_action :authenticate_customer!
  
  def show
    @equipment_item = EquipmentItem.find(params[:id], _location_id: params[:location_id], _account_id: current_customer.current_account_id)
    render json: @equipment_item
  end
  
end
