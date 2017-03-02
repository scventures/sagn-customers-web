class EquipmentItem
  include Her::Model
  alias :read_attribute_for_serialization :send
  parse_root_in_json :equipment_items, format: :active_model_serializers
  collection_path 'customers/accounts/:account_id/locations/:location_id/equipment_items'
  attributes :id, :model, :serial, :brand_name, :location_id
  
  belongs_to :location
  belongs_to :category
  belongs_to :sub_category
  
  def as_json(options = nil)
    attributes.except(:location).as_json
  end

end
