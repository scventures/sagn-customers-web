class LocationsController < ApplicationController

  before_action :authenticate_customer!
  
  def equipments
    location = Location.find(params[:id])
    equipments = location.equipment_items
    render json: equipments
  end
  
end
