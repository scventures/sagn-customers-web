class VenuesController < ApplicationController
  
  before_action :authenticate_customer!, only: :images
  before_action :set_client
  
  def index
    render json: @client.search_venues(search_params)
  rescue => error
    render json: {error: error.message}, status: 400
  end

  def images
    render json: @client.venue_photos(photos_params[:id], limit: 1)
  rescue => error
    render json: {error: error.message}, status: 400
  end
  
  private
    
  def search_params
    params.permit(:ll, :near, :query, :limit, :intent )
  end

  def set_client
    @client = Foursquare2::Client.new( api_version: 20170608, client_id: ENV['FOURSQUARE_CLIENT_ID'], client_secret: ENV['FOURSQUARE_CLIENT_SECRET'])
  end
  
  def photos_params
    params.permit(:id)
  end

end
