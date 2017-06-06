require 'rails_helper'

RSpec.describe 'route to service request assignments customer ratings', type: :routing do
  it 'routes /service_requests/service_request_assignments/:service_request_assignment_id/customer_ratings to service_requests/service_request_assignments/customer_ratings#create to customer rating' do
    expect(post: '/service_requests/service_request_assignments/:service_request_assignment_id/customer_ratings').to route_to(
      controller: 'service_requests/service_request_assignments/customer_ratings',
      action: 'create',
      service_request_assignment_id: ':service_request_assignment_id'
    )
  end
end
