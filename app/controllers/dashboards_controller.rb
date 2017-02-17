class DashboardsController < ApplicationController

  before_action :authenticate_customer!

  def show
    @customer = current_customer.populate_attributes
  end

end
