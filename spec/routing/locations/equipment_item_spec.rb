require 'rails_helper'

RSpec.describe 'route to get location equipments', type: :routing do
  it 'routes /locations/:location_id/equipment_items to locations/equipment_items#index to show customer dashboard' do
    expect(get: '/locations/:location_id/equipment_items').to route_to(
      controller: 'locations/equipment_items',
      action: 'index',
      location_id: ':location_id'
    )
  end

end
