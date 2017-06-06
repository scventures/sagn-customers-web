require 'rails_helper'

RSpec.describe 'route to location', type: :routing do
 
  it 'routes /locations to locations#index  to show all locations' do
    expect(get: '/locations').to route_to(
      controller: 'locations',
      action: 'index'
    )
  end
  
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
  
  
  it 'routes /locations/:id/edit to locations#edit to edit location' do
    expect(get: '/locations/:id/edit').to route_to(
      controller: 'locations',
      action: 'edit',
      id: ':id'
    )
  end
  
  it 'routes /locations/:id to locations#update to update location' do
    expect(patch: '/locations/:id').to route_to(
      controller: 'locations',
      action: 'update',
      id: ':id'
    )
  end
  
  it 'routes /locations/:id to locations#update to update location' do
    expect(put: '/locations/:id').to route_to(
      controller: 'locations',
      action: 'update',
      id: ':id'
    )
  end
  
  it 'routes /locations/:id to locations#destroy to destroy location' do
    expect(delete: '/locations/:id').to route_to(
      controller: 'locations',
      action: 'destroy',
      id: ':id'
    )
  end
end
