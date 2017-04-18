class VenuesController < ApplicationController
  
  before_action :authenticate_customer!
  
  def index
    if params[:ll]
      venues = Venue.all(ll: params[:ll], query: params[:query])
    else
      venues = Venue.all(query: params[:query], intent: 'checkin')
    end
    render json: venues, each_serializer: VenueSerializer
  end
  
end
