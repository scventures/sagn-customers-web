class VenuesController < ApplicationController
  
  
  def index
    if params[:ll]
      venues = Venue.all(ll: params[:ll], query: params[:query])
    else
      venues = Venue.all(query: params[:query], intent: params[:intent])
    end
    render json: venues, each_serializer: VenueSerializer
  end
  
end
