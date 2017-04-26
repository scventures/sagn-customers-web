class Location
  include Her::Model
  alias :read_attribute_for_serialization :send
  parse_root_in_json :location, format: :active_model_serializers
  collection_path 'customers/accounts/:account_id/locations'
  include_root_in_json true

  attributes :id, :name, :address_1, :address_2, :address_3, :city, :state, :zip, :geography, :phone_number
  has_many :equipment_items
  has_many :service_requests
  validates_presence_of :name
  
  def full_address
    [address_1, address_2, address_3, city, state, zip].compact.reject { |a| a == "" }.join(", ")
  end
  
end
