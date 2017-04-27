class Locations::EquipmentItemsController < ApplicationController

  before_action :authenticate_customer!
  
  def index
    @equipment_items = EquipmentItem.all(_account_id: current_customer.current_account_id, _location_id: params[:location_id], subcategory_id: params[:subcategory_id]).fetch()
    render json: @equipment_items, each_serializer: EquipmentItemSerializer
  end
  
end
