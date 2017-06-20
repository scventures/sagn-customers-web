class Activity
  include Her::Model
  parse_root_in_json :activities, format: :active_model_serializers
  belongs_to :service_request

  def customer_accepted?
    self.action == 'customer_accepted'  
  end
  
  def customer_declined?
    self.action == 'customer_declined'
  end
  
  def accepted?
    self.action == 'accepted'
  end
  
  def declined?
    self.action == 'declined'
  end

  def assignment
    #polymorphic association is not yet supported by HER ORM
    if trackable_type == 'ServiceRequestsAssignment'
      service_request.service_requests_assignments.find {|a| a[:id] == trackable_id}
    end
  end
  
  def estimation
    if trackable_type == 'Estimation'
      assignment = service_request[:service_requests_assignments].find { |s| s[:current_estimation][:id] == trackable_id}
      assignment[:current_estimation]
    end
  end

end
