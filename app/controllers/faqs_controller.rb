class FaqsController < ApplicationController

  before_action :authenticate_customer!
  skip_before_filter :check_for_registration

  def index
    @faqs = current_customer.get_faqs
    respond_to do |format|
      format.html
    end
   end

end

