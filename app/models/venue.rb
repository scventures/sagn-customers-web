class Venue
  include Her::Model
  use_api BASIC_AUTH
  alias :read_attribute_for_serialization :send
  parse_root_in_json :venues, format: :active_model_serializers
  collection_path 'customers/venues'

  def self.images(venue_id)
    Venue.get_raw('customers/venue_photos', venue_id: venue_id) do |parsed_data, response|
      populate_errors(parsed_data[:errors]) if response.status == 400
      images = parsed_data[:data] if response.status == 200
    end
  end

end
