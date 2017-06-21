class LocationsController < ApplicationController

  before_action :authenticate_customer!
  
  def index
    @location = Location.new
    @locations = current_customer.current_account.locations
    respond_to do |format|
      format.html
      format.json { render json: @locations, each_serializer: LocationSerializer}
    end
  end

  def create
    @location = current_customer.current_account.locations.build(location_params)
    if @location.save
      redirect_to request.referrer || locations_path
    else
      respond_to do |format|
        format.js { render partial: "locations/form", locals: { location: @location }, within: ".location-form-container" }
      end
    end
  end
  
  def edit
    @location = current_customer.current_account.locations.find(params[:id])
    respond_to do |format|
      format.js
    end
  end
  
  def update
    @location = current_customer.current_account.locations.build(id: params[:id])
    @location.assign_attributes location_params
    if @location.save
      redirect_to locations_path, notice: 'Location updated successfully'
    else
      respond_to do |format|
        format.js { render partial: "locations/edit", locals: { location: @location }, replace: ".location-form-container" }
      end
    end
  end
  
  def destroy
    @location = current_customer.current_account.locations.build(id: params[:id])
    if @location.destroy
      redirect_to locations_path, notice: 'Location deleted successfully'
    else
      redirect_to locations_path, alert: @location.errors.full_messages.join(', ')
    end
  end
  
  private
  
  def location_params
    params.required(:location).permit(
      :name, :address_1, :address_2, :address_3, :city, :state, :zip, :phone_number, :foursquare_venue_id, {:geography => [:latitude, :longitude]}, :id
    ).to_h
  end

end
