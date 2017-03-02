class ServiceRequest
  include Her::Model
  collection_path 'customers/accounts/:account_id/service_requests'
  include_root_in_json true
  attributes :location_id, :equipment_id, :model, :serial, :brand_name, :brand_id, :category_id, :subcategory_id, :urgent, :problem, :account_id, :equipmemt_warranty,
           :work_time_details, :customer_accounts_contractor_id, :select_guy, :catergory_search
  
  has_many :issue_images
  accepts_nested_attributes_for :issue_images
  validates_presence_of :location_id, :category_id, :subcategory_id
  
end
