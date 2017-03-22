require 'rails_helper'

RSpec.describe 'route to location', type: :routing do
  it 'routes /locations/new to locations#new to show location form' do
    expect(get: '/locations/new').to route_to(
      controller: 'locations',
      action: 'new'
    )
  end
  
  it 'routes /locations to locations#create to create location ' do
    expect(post: '/locations').to route_to(
      controller: 'locations',
      action: 'create'
    )
  end
  
  it 'routes /locations/:id to locations#show to show location details' do
    expect(get: '/locations/:id').to route_to(
      controller: 'locations',
      action: 'show',
      id: ':id'
    )
  end
end
