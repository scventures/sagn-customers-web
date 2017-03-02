class DashboardsController < ApplicationController

  before_action :authenticate_customer!

  def show
    @multiple_accounts = []
    current_customer.customer_account_ids.each do |account_id|
      @multiple_accounts << Account.find(account_id)
    end
  end

end
