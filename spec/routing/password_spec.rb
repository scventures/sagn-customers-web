require 'rails_helper'

RSpec.describe "route to password new", type: :routing do
  it "routes /password/new to customers/passwords#new to show signin page" do
    expect(get: "/password/new").to route_to(
      controller: "customers/passwords",
      action: "new"
    )
  end
  
  it "routes /password/edit to customers/passwords#edit to show signin page" do
    expect(get: "/password/edit").to route_to(
      controller: "customers/passwords",
      action: "edit"
    )
  end
  
  it "routes /password to customers/passwords#new to show signin page" do
    expect(patch: "/password").to route_to(
      controller: "customers/passwords",
      action: "update"
    )
  end

end
