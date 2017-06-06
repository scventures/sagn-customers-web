require 'rails_helper'

RSpec.describe 'route to service request', type: :routing do
  it 'routes /service_requests to service_requests#index to show all service request' do
    expect(get: '/service_requests').to route_to(
      controller: 'service_requests',
      action: 'index'
    )
  end
end
