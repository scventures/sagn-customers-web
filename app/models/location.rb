class Location
  include Her::Model
  alias :read_attribute_for_serialization :send
  parse_root_in_json :location, format: :active_model_serializers
  collection_path 'customers/accounts/:account_id/locations'
  include_root_in_json true

  attributes :id, :name, :address_1, :address_2, :address_3, :city, :state, :zip, :geography, :phone_number, :foursquare_venue_id, :account_id
  has_many :equipment_items
  has_many :service_requests
  has_many :categories, path: '/categories', class_name: 'Category'
  
  validates_presence_of :name, :address_1
  
  def full_address
    [address_1, address_2, address_3, city, state, zip].compact.reject { |a| a == "" }.join(", ")
  end
  
  def geography=(value)
    value = value.to_h if value.is_a?(ActionController::Parameters)
    unless value[:lattitude] and value[:longitude]
      if latlng = Geocoder.coordinates(full_address)
        value[:latitude], value[:longitude] = latlng
      else
        self.errors.add(:address_1, 'Invalid Address')
      end
    end
    super(value)
  end
  
  def create_or_find_location(current_account)
    return self if self.save
    if self.errors[:name].include? 'Location already exists'
      current_account.locations.detect {|l| l.name == self.name }
    elsif self.errors[:address_1].include? 'Location already exists'
      current_account.locations.detect {|l| l.address_1 == self.address_1 }
    end
  end

end
