class Estimation
  include Her::Model
  parse_root_in_json :estimation, format: :active_model_serializers
  collection_path 'customers/accounts/:account_id/service_requests/:service_request_id/estimations'
  belongs_to :service_request
  attributes :reason  
  
  DECLINE_REASONS = {
    found_another_technician: 'Found another technician',
    price_too_high: 'Price too high',
    dont_like_contractor: 'Don\'t like/trust contractor',
    other: 'Other Reason'
  }
  
end
