require 'rails_helper'

RSpec.describe 'route to root page', type: :routing do
  it 'routes /sign_in to customers/sessions#new to show home page' do
    expect(get: '/sign_in').to route_to(
      controller: 'customers/sessions',
      action: 'new'
    )
  end

end
