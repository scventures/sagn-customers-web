class Assignment
  include Her::Model
  parse_root_in_json :service_requests_assignment, format: :active_model_serializers
  collection_path 'customers/accounts/:account_id/service_requests/:service_request_id/assignments'
  belongs_to :service_request
  has_many :customer_ratings
  attributes :account_id, :service_request_id, :id, :status, :reason
  
  CUSTOMER_DECLINE_REASONS = {
    customer_bad_experience: 'I\'ve had a bad experience with this company or technician',
    customer_long_to_arrive: 'It will take too long for the technician to arrive',
    customer_canceled: 'I no longer need service',
    diagnostic_fee_is_too_high: 'Diagnostic fee is too high',
    customer_other: 'Other Reason'
  }
  
  def diagnostic_fee
    money = Money.new(self.diagnostic_fee_cents)
  end 
  
  def responded?
    self.status ==  'responded'
  end
  
  def customer_accepted?
    self.status == 'customer_accepted'
  end
  
  def customer_accepting?
    self.status == 'customer_accepting'
  end
  
  def waiting?
    self.status == 'waiting'
  end
  
  def start_accepting
    Assignment.post_raw("customers/accounts/#{account_id}/service_requests/#{service_request_id}/assignments/#{id}/start_accepting", {}) do |parsed_data, response|
      populate_errors(parsed_data[:errors]) if response.status == 400
    end
  end
  
  def accept(token)
    Assignment.post_raw("customers/accounts/#{account_id}/service_requests/#{service_request_id}/assignments/#{id}/accept", {stripe_token: token} ) do |parsed_data, response|
      if response.status == 400
        populate_errors(parsed_data[:errors])
      elsif response.status == 200
        return true
      end
    end
  end

  def decline
    Assignment.post_raw("customers/accounts/#{account_id}/service_requests/#{service_request_id}/assignments/#{id}/decline", {account_id: account_id, service_request_id: service_request_id, id: id, reason: reason}) do |parsed_data, response|
      populate_errors(parsed_data[:errors]) if response.status == 400
    end
  end
  
  def start_accepting_estimation
    Assignment.post_raw("customers/accounts/#{account_id}/service_requests/#{service_request_id}/assignments/#{id}/start_accepting_estimation" ) do |parsed_data, response|
      if response.status == 400
        populate_errors(parsed_data[:errors])
      elsif response.status == 200
        return true
      end
    end
  end
  
  def accept_estimation(token)
    Assignment.post_raw("customers/accounts/#{account_id}/service_requests/#{service_request_id}/assignments/#{id}/accept_estimation", {stripe_token: token} ) do |parsed_data, response|
      if response.status == 400
        populate_errors(parsed_data[:errors])
      elsif response.status == 200
        return true
      end
    end
  end
  
  def decline_estimation(reason)
    Assignment.post_raw("customers/accounts/#{account_id}/service_requests/#{service_request_id}/assignments/#{id}/decline_estimation", {reason: reason} ) do |parsed_data, response|
      if response.status == 400
        populate_errors(parsed_data[:errors])
      elsif response.status == 200
        return true
      end
    end
  end
  
  def consider_estimation
    Assignment.post_raw("customers/accounts/#{account_id}/service_requests/#{service_request_id}/assignments/#{id}/consider_estimation") do |parsed_data, response|
      if response.status == 400
        populate_errors(parsed_data[:errors])
      elsif response.status == 200
        return true
      end
    end
  end
end
