class ServiceRequest
  include Her::Model
  parse_root_in_json :service_request, format: :active_model_serializers
  collection_path 'customers/accounts/:account_id/service_requests'
  resource_path 'customers/accounts/:account_id/service_requests/:id'
  include_root_in_json true
  attributes :location_id, :equipment_item_id, :model, :serial, :brand_name, :brand_id, :category_id, :subcategory_id, :subcategory, :urgent, :problem_code_id, 
             :account_id, :equipmemt_warranty, :work_time_details, :customer_accounts_contractor_id, :select_guy, :catergory_search, :notes,
             :contact_details, :phone_number, :token
  
  has_many :issue_images
  has_many :activities
  has_many :assignments
  has_many :estimations
  
  accepts_nested_attributes_for :issue_images
  validates :location_id, :category_id, :subcategory_id, presence: true

  before_save :set_urgent, :set_brand_and_equipment
  
  def assigned?
    status == 'assigned'
  end
  
  def can_editable?
    self.status == 'waiting'
  end
  
  def completed?
    self.status == 'completed'
  end
  
  def cancel
    ServiceRequest.put_raw("customers/accounts/#{account_id}/service_requests/#{id}/cancel", {account_id: account_id, id: id}) do |parsed_data, response|
      populate_errors(parsed_data[:errors]) if response.status == 400
    end
  end
  
  def set_urgent
    self.urgent = self.urgent.to_b
  end
  
  def set_brand_and_equipment
    self.brand_id = nil if self.brand_id and self.brand_id.to_i == 0
    self.equipment_item_id = nil if self.equipment_item_id and self.equipment_item_id.to_i == 0
  end
  
  def to_params
    if new_record? and token?
      params = super
      params[:service_request].delete(:token)
      params.merge(stripe_token: token)
    else
      super
    end
  end

end
