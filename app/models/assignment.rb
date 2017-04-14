class Assignment
  include Her::Model
  parse_root_in_json :service_requests_assignments, format: :active_model_serializers
  collection_path 'customers/accounts/:account_id/service_requests/:service_request_id/assignments'
  belongs_to :service_request
  attributes :account_id, :service_request_id, :id, :status, :reason
  
  CUSTOMER_DECLINE_REASONS = {
    customer_bad_experience: 'I\'ve had a bad experience with this company or technician',
    customer_long_to_arrive: 'It will take too long for the technician to arrive',
    customer_canceled: 'I no longer need service',
    diagnostic_fee_is_too_high: 'Diagnostic fee is too high',
    customer_other: 'Other Reason'
  }
  
  def responded?
    self.status ==  'responded'
  end
  
  def customer_accepted?
    self.status == 'customer_accepted'
  end
  
  def waiting?
    self.status == 'waiting'
  end
  
  def accept
    Assignment.post_raw("customers/accounts/#{account_id}/service_requests/#{service_request_id}/assignments/#{id}/accept", {account_id: account_id, service_request_id: service_request_id, id: id}) do |parsed_data, response|
      populate_errors(parsed_data[:errors]) if response.status == 400
    end
  end
  
  def decline
    Assignment.post_raw("customers/accounts/#{account_id}/service_requests/#{service_request_id}/assignments/#{id}/decline", {account_id: account_id, service_request_id: service_request_id, id: id, reason: reason}) do |parsed_data, response|
      populate_errors(parsed_data[:errors]) if response.status == 400
    end
  end
  
end
