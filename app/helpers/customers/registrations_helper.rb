module Customers::RegistrationsHelper

  def tos_label
    tos_link = link_to 'Terms of use', '#'
    privacy_policy_link = link_to 'privacy Policy', '#'
    "Accept #{tos_link} and #{privacy_policy_link}".html_safe
  end

end
