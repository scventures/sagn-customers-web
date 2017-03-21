require 'rails_helper'

RSpec.describe 'route to sign in customer', type: :routing do
  it 'routes /dashboard to dashboards#show to show customer dashboard' do
    expect(get: '/dashboard').to route_to(
      controller: 'dashboards',
      action: 'show'
    )
  end

end
