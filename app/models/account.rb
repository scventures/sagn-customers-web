class Account
  include Her::Model
  parse_root_in_json :customer_account
  resource_path "customers/accounts/:id"
  
  attributes :id
  has_many :locations
  has_many :contractors
  has_many :staff

end
