require 'rails_helper'

RSpec.describe "route to sign in customer", type: :routing do
  it "routes /sign_in to customers/sessions#new to show signin page" do
    expect(get: "/sign_in").to route_to(
      controller: "customers/sessions",
      action: "new"
    )
  end
  
  it "routes /sign_in to customers/sessions#create to signin customer" do
    expect(post: "/sign_in").to route_to(
      controller: "customers/sessions",
      action: "create"
    )
  end
  
  it "routes /sign_out to customers/sessions#destroy to signout customer" do
    expect(delete: "/sign_out").to route_to(
      controller: "customers/sessions",
      action: "destroy"
    )
  end

end
