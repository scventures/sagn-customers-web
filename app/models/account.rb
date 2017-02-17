class Account
  include Her::Model
  parse_root_in_json :customer_account
  collection_path "customers/accounts"
  
  attributes :id
  has_many :locations
  has_many :contractors

end
