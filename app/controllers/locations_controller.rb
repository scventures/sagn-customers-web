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
    if @location.errors.blank? and @location.save
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
  
  def create_with_service_request
    loc = Location.new location_params
    @current_account = current_customer.current_account
    loc.account_id = @current_account.id
    if @location = loc.create_or_find_location(@current_account)
      @service_request = ServiceRequest.new service_request_params
      @service_request.account_id = @current_account.id
      @service_request.location_id = @location.id
      @service_request.issue_images = Her::Collection.new unless params[:service_request][:issue_images_attributes]
      @categories = Category.all.fetch.group_by(&:parent_category_id)
      if @current_account.have_payment_method
        if @service_request.save
          redirect_to current_requests_path, flash: {service_request_id: @service_request.id}
        else
          render 'create_with_service_request' and return
        end
      else
        render 'create_with_service_request' and return
      end
    else
      redirect_to locations_path, alert: location.errors.full_messages.join(', ')
    end
  end
  
  private
  
  def location_params
    params.required(:location).permit(
      :name, :address_1, :address_2, :address_3, :city, :state, :zip, :phone_number, :foursquare_venue_id, {:geography => [:latitude, :longitude]}, :id
    ).to_h
  end
  
  def service_request_params
    permitted_params = params.required(:service_request).permit(
      :location_id, :problem_code_id, :equipment_item_id, :brand_name, :brand_id, :model, :serial, :urgent, :work_time_details, :select_guy,
      :category_id, :subcategory_id, :token, :phone_number, :notes, :contact_details, issue_images_attributes: [:image, :image_base64, :_destroy]
    ).to_h
    permitted_params.merge(location_id: params[:location_id])
  end
  
end
