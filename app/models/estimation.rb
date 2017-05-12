class Estimation
  include Her::Model
  parse_root_in_json :estimation, format: :active_model_serializers
  collection_path 'customers/accounts/:account_id/service_requests/:service_request_id/estimations'
  belongs_to :service_request
  
end
