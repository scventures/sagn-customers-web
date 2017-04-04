class Contractor
  include Her::Model
  parse_root_in_json :customer_accounts_contractors, format: :active_model_serializers
  collection_path 'customers/accounts/:account_id/contractors'
  resource_path 'customers/accounts/:account_id/contractors/:id'
  include_root_in_json :customer_accounts_contractor
  attributes :id, :customer_account_id, :contractor_id, :contractor_name, :contractor_account_id, :contractor_account_name, :business_name,
             :contact_name, :email, :phone_number, :status, :_destroy

  belongs_to :account

  validates_presence_of :email, :contact_name, :business_name

end
