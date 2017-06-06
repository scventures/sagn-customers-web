require 'rails_helper'

RSpec.describe 'route to location service requests', type: :routing do
  it 'routes /locations/:location_id/service_requests/new to locations/service_requests#new to new service request' do
    expect(get: '/locations/:location_id/service_requests/new').to route_to(
      controller: 'locations/service_requests',
      action: 'new',
      location_id: ':location_id'
    )
  end

  it 'routes /locations/:location_id/service_requests to locations/service_requests#create to create service request' do
    expect(post: '/locations/:location_id/service_requests').to route_to(
      controller: 'locations/service_requests',
      action: 'create',
      location_id: ':location_id'
    )
  end
  
  it 'routes /locations/:location_id/service_requests/:id/edit to locations/service_requests#edit to edit service request' do
    expect(get: '/locations/:location_id/service_requests/:id/edit').to route_to(
      controller: 'locations/service_requests',
      action: 'edit',
      location_id: ':location_id',
      id: ':id'
    )
  end
  
  it 'routes /locations/:location_id/service_requests/:id to locations/service_requests#update to update service request' do
    expect(patch: '/locations/:location_id/service_requests/:id').to route_to(
      controller: 'locations/service_requests',
      action: 'update',
      location_id: ':location_id',
      id: ':id'
    )
  end
  
  it 'routes /locations/:location_id/service_requests/:id to locations/service_requests#update to update service request' do
    expect(put: '/locations/:location_id/service_requests/:id').to route_to(
      controller: 'locations/service_requests',
      action: 'update',
      location_id: ':location_id',
      id: ':id'
    )
  end
end
