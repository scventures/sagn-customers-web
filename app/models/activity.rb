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
  
end
