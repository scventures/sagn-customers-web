class LocationsController < ApplicationController

  before_action :authenticate_customer!

  def new
    @location = Location.new
  end
  
  def create
    @location = Location.new(location_params.to_h.merge(account_id: current_customer.current_account_id))
    if @location.save
      redirect_to location_path(@location)
    else
      respond_to do |format|
        format.js { render partial: "locations/form", locals: { location: @location }, replace: ".location-form-container" }
      end
    end
  end
  
  def show
    @location = Location.find(params[:id], _account_id: current_customer.current_account_id)
  end
  
  private
  
  def location_params
    params.required(:location).permit(
      :name, :address_1, :address_2, :address_3, :city, :state, :zip_code, :geography
    ).to_h
  end

end
