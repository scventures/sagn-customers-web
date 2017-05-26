class VenuesController < ApplicationController
  
  before_action :authenticate_customer!, only: :images
  
  def index
    if params[:ll]
      venues = Venue.all(ll: params[:ll], query: params[:query])
    else
      venues = Venue.all(query: params[:query], intent: params[:intent])
    end
    render json: venues, each_serializer: VenueSerializer
  end

  def images
    @location = current_customer.current_account.locations.find(params[:id])
    @images = Venue.images(@location.foursquare_venue_id) unless @location.foursquare_venue_id.nil? or @location.foursquare_venue_id.blank?
    respond_to do |format|
      format.js
    end
  end

end
