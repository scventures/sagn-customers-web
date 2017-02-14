class Location
  include Her::Model
  parse_root_in_json true, format: :active_model_serializers

  attributes :id, :name
  has_many :equipment_items
  
end
