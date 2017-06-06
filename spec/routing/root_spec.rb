require 'rails_helper'

RSpec.describe 'route to root page', type: :routing do
  let(:customer) { Customer.new(jwt: jwt) }
  it 'routes / to customers#new to new customer' do
    expect(get: '/').to route_to(
      controller: 'customers',
      action: 'new'
    )
  end

end
