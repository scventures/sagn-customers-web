require 'rails_helper'

RSpec.describe 'route to current request', type: :routing do
  it 'routes /current_requests to current_requests#index to show all current requests' do
    expect(get: '/current_requests').to route_to(
      controller: 'current_requests',
      action: 'index'
    )
  end
  
  it 'routes /current_requests/:id to current_requests#show to show current request' do
    expect(get: '/current_requests/:id').to route_to(
      controller: 'current_requests',
      action: 'show',
      id: ':id'
    )
  end
  
  it 'routes /current_requests/:current_request_id/cancel to current_requests#cancel to cancel current request' do
    expect(get: '/current_requests/:current_request_id/cancel').to route_to(
      controller: 'current_requests',
      action: 'cancel',
      current_request_id: ':current_request_id'
    )
  end
end
