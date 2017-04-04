require 'rails_helper'

RSpec.describe 'route to contractor', type: :routing do

  it 'routes /contractors to contractors#index  to show all contractors' do
    expect(get: '/contractors').to route_to(
      controller: 'contractors',
      action: 'index'
    )
  end

  it 'routes /contractors/new to contractors#new to show contractor form' do
    expect(get: '/contractors/new').to route_to(
      controller: 'contractors',
      action: 'new'
    )
  end

  it 'routes /contractors to contractors#create to create contractor ' do
    expect(post: '/contractors').to route_to(
      controller: 'contractors',
      action: 'create'
    )
  end

  it 'routes /contractors/create_multiple to contractors#create_multiple to create multiple contractors ' do
    expect(patch: '/contractors/create_multiple').to route_to(
      controller: 'contractors',
      action: 'create_multiple'
    )
  end

  it 'routes /contractors/:id to contractors#destroy to destroy contractor' do
    expect(delete: '/contractors/:id').to route_to(
      controller: 'contractors',
      action: 'destroy',
      id: ':id'
    )
  end
end
