class LocationsController < ApplicationController

  before_action :authenticate_customer!
  
  def index
    @locations = current_customer.current_account.locations
  end

  def new
    @location = Location.new
  end
  
  def create
    @location = current_customer.current_account.locations.build(location_params)
    if @location.save
      redirect_to locations_path
    else
      respond_to do |format|
        format.js { render partial: "locations/form", locals: { location: @location }, replace: ".location-form-container" }
      end
    end
  end
  
  def edit
    @location = current_customer.current_account.locations.find(params[:id])
  end
  
  def update
    @location = current_customer.current_account.locations.build(id: params[:id])
    @location.assign_attributes location_params
    if @location.save
      redirect_to locations_path, notice: 'Location updated successfully'
    else
      respond_to do |format|
        format.js { render partial: "locations/form", locals: { location: @location }, replace: ".location-form-container" }
      end
    end
  end
  
  def show
    @location = current_customer.current_account.locations.find(params[:id])
  end
  
  def destroy
    @location = current_customer.current_account.locations.build(id: params[:id])
    if @location.destroy
      redirect_to locations_path, notice: 'Location deleted successfully'
    else
      redirect_to locations_path, alert: @staff.errors.full_messages.join(', ')
    end
  end
  
  private
  
  def location_params
    params.required(:location).permit(
      :name, :address_1, :address_2, :address_3, :city, :state, :zip, :phone_number, :geography
    ).to_h
  end

end
