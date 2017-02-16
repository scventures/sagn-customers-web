class ServiceRequest
  include Her::Model
  collection_path 'customers/accounts/:account_id/service_requests'
  include_root_in_json true

  attributes :location_id, :equipment_id, :model, :serial, :brand_name, :category_id, :subcategory_id, :urgent, :problem, :account_id
  
  before_save :set_category_and_subcategory
  
  has_many :issue_images
  accepts_nested_attributes_for :issue_images
  
  def set_category_and_subcategory
    ServiceRequest.get_raw("customers/accounts/#{self.account_id}/locations/#{self.location_id}/equipment_items/#{self.equipment_id}") do |parsed_data, response|
      if response.status == 404
        parsed_data[:data].each do |k, v|
          service_request.errors.add(k, v.first)
        end
      else
        equipment = EquipmentItem.find(self.equipment_id, _location_id: self.location_id, _account_id: self.account_id)
        self.category_id = equipment.equipment_item[:category][:id]
        self.subcategory_id = equipment.equipment_item[:subcategory][:id]
      end
    end
  end
  
end
