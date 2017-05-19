class Venue
  include Her::Model
  use_api BASIC_AUTH
  alias :read_attribute_for_serialization :send
  parse_root_in_json :venues, format: :active_model_serializers
  collection_path 'customers/venues'
end
