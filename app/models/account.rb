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
  
  def current_requests
    current = self.current_service_requests.select {|c| c.is_active and !['cancelled', 'final_bill_sent', 'completed', 'customer_declined_estimation'].include?(c.latest_activity_status_raw) }
    past = self.past_service_requests.select {|c| c.is_active and !['cancelled', 'final_bill_sent', 'completed', 'customer_declined_estimation'].include?(c.latest_activity_status_raw) }
    current += past
    current.uniq! {|c| c.id}
    current.sort_by!(&:created_at).reverse if current
    current
  end
  
  def past_requests
    past = self.past_service_requests.select {|c| !c.is_active or ['cancelled', 'final_bill_sent', 'completed', 'customer_declined_estimation'].include?(c.latest_activity_status_raw) }
    current = self.current_service_requests.select {|c| !c.is_active or ['cancelled', 'final_bill_sent', 'completed', 'customer_declined_estimation'].include?(c.latest_activity_status_raw) }
    past += current
    past.uniq! {|p| p.id}
    past.sort_by!(&:created_at).reverse if past
    past
  end

end
