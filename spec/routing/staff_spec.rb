require 'rails_helper'

RSpec.describe 'route to staff', type: :routing do
  it 'routes /staffs/new to staffs#new to show staff form' do
    expect(get: '/staffs/new').to route_to(
      controller: 'staffs',
      action: 'new'
    )
  end
  
  it 'routes /staffs to staffs#create to create staff ' do
    expect(post: '/staffs').to route_to(
      controller: 'staffs',
      action: 'create'
    )
  end
  
  it 'routes /staffs to staffs#index to show staff details' do
    expect(get: 'staffs#index').to route_to(
      controller: 'staffs',
      action: 'index'
    )
  end
end
