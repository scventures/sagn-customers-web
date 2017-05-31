module Customers::RegistrationsHelper

  def tos_label
    tos_link = link_to 'Terms of use', page_path('terms_of_use')
    privacy_policy_link = link_to 'privacy Policy', page_path('terms_of_use')
    "Accept #{tos_link} and #{privacy_policy_link}".html_safe
  end

end
