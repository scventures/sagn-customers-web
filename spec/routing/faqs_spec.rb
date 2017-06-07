require 'rails_helper'

RSpec.describe 'route to faqs', type: :routing do
  it 'routes /faqs to faqs#index to get faqs' do
    expect(get: '/faqs').to route_to(
      controller: 'faqs',
      action: 'index'
    )
  end
end
