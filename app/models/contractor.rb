class Contractor
  include Her::Model
  parse_root_in_json :customer_accounts_contractors, format: :active_model_serializers
  collection_path 'customers/accounts/:customer_account_id/contractors'
  attributes :id, :customer_account_id, :contractor_id, :contractor_name, :contractor_account_id, :contractor_account_name, :business_name,
             :contact_name, :email, :phone_number, :status

  belongs_to :account

end
