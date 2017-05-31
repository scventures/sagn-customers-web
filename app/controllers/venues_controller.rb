class VenuesController < ApplicationController
  
  before_action :authenticate_customer!, only: :images
  
  def index
    venues = Venue.all(params)
    render json: venues, each_serializer: VenueSerializer
  end

  def images
    venue = Venue.new(id: params[:id])
    images = venue.images
    render json: images
  end

end
