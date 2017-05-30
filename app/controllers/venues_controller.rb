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
    venue = Venue.new(id: params[:id])
    images = venue.images
    render json: images
  end

end
