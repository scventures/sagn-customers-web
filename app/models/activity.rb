class Activity
  include Her::Model
  parse_root_in_json :activities, format: :active_model_serializers
  belongs_to :service_request
end
