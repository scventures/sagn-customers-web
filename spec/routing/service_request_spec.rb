require 'rails_helper'

RSpec.describe "route to service request", type: :routing do
  it "routes /service_requests/new to service_requests#new to show service request form" do
    expect(get: "/service_requests/new").to route_to(
      controller: "service_requests",
      action: "new"
    )
  end
  
  it "routes /service_requests to service_requests#create to create service" do
    expect(post: "/service_requests").to route_to(
      controller: "service_requests",
      action: "create"
    )
  end
end
