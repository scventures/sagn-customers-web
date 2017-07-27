class Staff
  include Her::Model
  parse_root_in_json :customer_account_customers, format: :active_model_serializers
  collection_path 'customers/accounts/:account_id/staff'
  resource_path 'customers/accounts/:account_id/staff/:id'
  include_root_in_json :customer
  
  before_save :set_name
  attributes :id, :name, :first_name, :last_name, :email, :_destroy
  belongs_to :account
  validates_presence_of :first_name, :last_name, :email
  
  def set_name
    self.name = [first_name, last_name].compact.join(' ')
  end
  
  def account_owner?
    self.role == 'account_owner'
  end
  
end
