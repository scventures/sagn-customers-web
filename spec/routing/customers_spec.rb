require 'rails_helper'

RSpec.describe 'Customer routes', type: :routing do
  it 'routes /customers/new to customers#new for new customer' do
    expect(get: '/customers/new').to route_to(
      controller: 'customers',
      action: 'new'
    )
  end
  
  it 'routes /customers/layer_identity to customers#layer_identity to get layer id for customer' do
    expect(post: '/customers/layer_identity').to route_to(
      controller: 'customers',
      action: 'layer_identity'
    )
  end
  
  it 'routes /customers/verify_customer to customers#verify_customer to verify customer confirmation' do
    expect(get: '/customers/verify_customer').to route_to(
      controller: 'customers',
      action: 'verify_customer'
    )
  end
  
end
