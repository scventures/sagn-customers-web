require 'rails_helper'

RSpec.describe 'registrations routes', type: :routing do
  it 'routes /cancel to customers/registrations#cancel to cancel customer registration' do
    expect(get: '/cancel').to route_to(
      controller: 'customers/registrations',
      action: 'cancel'
    )
  end
  
  it 'routes /sign_up to customers/registrations#new to signup customer' do
    expect(get: '/sign_up').to route_to(
      controller: 'customers/registrations',
      action: 'new'
    )
  end
  
  it 'routes /edit to customers/registrations#edit to edit customer' do
    expect(get: '/edit').to route_to(
      controller: 'customers/registrations',
      action: 'edit'
    )
  end
  
  it 'routes / to customers/registrations#update to update(patch method) customer' do
    expect(patch: '/').to route_to(
      controller: 'customers/registrations',
      action: 'update'
    )
  end
  
  it 'routes / to customers/registrations#update to update(put method) customer' do
    expect(put: '/').to route_to(
      controller: 'customers/registrations',
      action: 'update'
    )
  end
  
  it 'routes / to customers/registrations#destroy to destroy customer' do
    expect(delete: '/').to route_to(
      controller: 'customers/registrations',
      action: 'destroy'
    )
  end
  
  it 'routes / to customers/registrations#create to create customer' do
    expect(post: '/').to route_to(
      controller: 'customers/registrations',
      action: 'create'
    )
  end
  
  it 'routes /customers/create_with_service_request to customers/registrations#create_with_service_request to create customer with service requests' do
    expect(post: '/customers/create_with_service_request').to route_to(
      controller: 'customers/registrations',
      action: 'create_with_service_request'
    )
  end
  
end
