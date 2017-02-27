class EquipmentItem
  include Her::Model
  parse_root_in_json :equipment_item
  resource_path 'customers/accounts/:account_id/locations/:location_id/equipment_items/:id'
  attributes :id, :model, :serial, :brand_name, :location_id
  
  belongs_to :location
  belongs_to :category
  belongs_to :sub_category
  
  def as_json(options = nil)
    attributes.except(:location).as_json
  end

end
