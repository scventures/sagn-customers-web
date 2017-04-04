require 'rails_helper'

RSpec.describe 'route to staff', type: :routing do
  it 'routes /staff/new to staffs#new to show staff form' do
    expect(get: '/staff/new').to route_to(
      controller: 'staff',
      action: 'new'
    )
  end
  
  it 'routes /staff to staff#create to create staff ' do
    expect(post: '/staff').to route_to(
      controller: 'staff',
      action: 'create'
    )
  end
  
  it 'routes /staff/create_multiple to staff#create_multiple to create multiple staff ' do
    expect(patch: '/staff/create_multiple').to route_to(
      controller: 'staff',
      action: 'create_multiple'
    )
  end
  
  it 'routes /staffs to staff#index to show staff details' do
    expect(get: 'staff#index').to route_to(
      controller: 'staff',
      action: 'index'
    )
  end
  
  it 'routes /staff/:id to staff#destroy to delete staff' do
    expect(delete: '/staff/:id').to route_to(
      controller: 'staff',
      action: 'destroy',
      id: ':id'
    )
  end
end
