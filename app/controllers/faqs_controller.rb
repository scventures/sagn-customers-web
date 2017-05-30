class FaqsController < ApplicationController

  before_action :authenticate_customer!

  def index
    @faqs = current_customer.get_faqs
    respond_to do |format|
      format.html
    end
   end

end

