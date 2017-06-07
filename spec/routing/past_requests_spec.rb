require 'rails_helper'

RSpec.describe 'route to past requests', type: :routing do
  it 'routes /past_requests to past_requests#index to get all past requests' do
    expect(get: '/past_requests').to route_to(
      controller: 'past_requests',
      action: 'index'
    )
  end
  
  it 'routes /past_requests/:id to past_requests#show to get all past requests' do
    expect(get: '/past_requests/:id').to route_to(
      controller: 'past_requests',
      action: 'show',
      id: ':id'
    )
  end
end
