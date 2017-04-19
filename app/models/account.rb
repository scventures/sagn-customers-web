class Account
  include Her::Model
  parse_root_in_json :customer_account
  resource_path "customers/accounts/:id"
  
  attributes :id
  has_many :locations
  has_many :contractors
  has_many :staff
  has_many :service_requests
  has_many :current_service_requests, path: '/service_requests/current', class_name: 'ServiceRequest'
  has_many :past_service_requests, path: '/service_requests/past', class_name: 'ServiceRequest'

  accepts_nested_attributes_for :contractors
  accepts_nested_attributes_for :staff

end
