class CustomerRating
  include Her::Model
  collection_path 'customers/accounts/:account_id/service_requests/:service_request_id/assignments/:assignment_id/ratings'
  attributes :stars, :comment, :assignment_id, :service_request_id, :account_id
  belongs_to :assignment
  
  def stars=(value)
    value = value.to_i
    super
  end
end
