class ServiceRequest
  include Her::Model
  parse_root_in_json :service_request, format: :active_model_serializers
  collection_path 'customers/accounts/:account_id/service_requests'
  resource_path 'customers/accounts/:account_id/service_requests/:id'
  include_root_in_json true
  attributes :location_id, :equipment_id, :model, :serial, :brand_name, :brand_id, :category_id, :subcategory_id, :urgent, :problem, :account_id, :equipmemt_warranty,
           :work_time_details, :customer_accounts_contractor_id, :select_guy, :catergory_search, :notes
  
  has_many :issue_images
  has_many :activities
  has_many :assignments
  
  accepts_nested_attributes_for :issue_images
  validates_presence_of :location_id, :category_id, :subcategory_id
  
  before_save :set_urgent
  
  def assigned?
    status == 'assigned'
  end
  
  def cancel
    ServiceRequest.put_raw("customers/accounts/#{account_id}/service_requests/#{id}/cancel", {account_id: account_id, id: id}) do |parsed_data, response|
      populate_errors(parsed_data[:errors]) if response.status == 400
    end
  end
  
  def set_urgent
    self.urgent = self.urgent.to_b
  end

end
