require 'rails_helper'

RSpec.describe 'confirmations routes', type: :routing do
  it 'routes /confirmation/new to customers/confirmations#new for customer confirmation' do
    expect(get: '/confirmation/new').to route_to(
      controller: 'customers/confirmations',
      action: 'new'
    )
  end
  
  it 'routes /confirmation to customers/confirmations#show to show customer confirmation' do
    expect(get: '/confirmation').to route_to(
      controller: 'customers/confirmations',
      action: 'show'
    )
  end
  
  it 'routes /confirmation to customers/confirmations#create to create customer confirmation' do
    expect(post: '/confirmation').to route_to(
      controller: 'customers/confirmations',
      action: 'create'
    )
  end
end
