require 'rails_helper'

RSpec.describe 'route to sign in customer', type: :routing do
  it 'routes /location/:location_id/equipment_items to location/equipment_items#index to show customer dashboard' do
    expect(get: '/location/:location_id/equipment_items').to route_to(
      controller: 'location/equipment_items',
      action: 'index',
      location_id: ':location_id'
    )
  end

end
