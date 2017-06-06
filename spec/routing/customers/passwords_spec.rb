require 'rails_helper'

RSpec.describe 'passwords routes', type: :routing do
  it 'routes /password/new to customers/passwords#new for new customer password' do
    expect(get: '/password/new').to route_to(
      controller: 'customers/passwords',
      action: 'new'
    )
  end  
  
  it 'routes /password/edit to customers/passwords#edit to edit customer password' do
    expect(get: '/password/edit').to route_to(
      controller: 'customers/passwords',
      action: 'edit'
    )
  end
  
  it 'routes /password to customers/passwords#update to update(patch method) customer password' do
    expect(patch: '/password').to route_to(
      controller: 'customers/passwords',
      action: 'update'
    )
  end
  
  it 'routes /password to customers/passwords#update(put method) to update customer password' do
    expect(put: '/password').to route_to(
      controller: 'customers/passwords',
      action: 'update'
    )
  end
  
  it 'routes /password to customers/passwords#create to create customer password' do
    expect(post: '/password').to route_to(
      controller: 'customers/passwords',
      action: 'create'
    )
  end
  
end
