class Staff
  include Her::Model
  parse_root_in_json :customer_account_customers, format: :active_model_serializers
  collection_path 'customers/accounts/:account_id/staff'
  resource_path 'customers/accounts/:account_id/staff/:id'
  include_root_in_json :customer

  attributes :id, :name, :email
  belongs_to :account
end
