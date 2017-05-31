class PagesController < ApplicationController
  include HighVoltage::StaticPage

  layout :layout_for_page

  private

  def layout_for_page
    case params[:id]
    when 'terms_of_use'
      customer_signed_in? ? 'application' : 'devise'
    else
      'devise'
    end
  end
end
