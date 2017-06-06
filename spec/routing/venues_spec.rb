require 'rails_helper'

RSpec.describe 'route to venues', type: :routing do
  it 'routes /venues to venues#index to get venues' do
    expect(get: '/venues').to route_to(
      controller: 'venues',
      action: 'index'
    )
  end
  
  it 'routes /venues/:id/images to venues#images to get venues images' do
    expect(get: '/venues/:id/images').to route_to(
      controller: 'venues',
      action: 'images',
      id: ':id'
    )
  end
  
end
