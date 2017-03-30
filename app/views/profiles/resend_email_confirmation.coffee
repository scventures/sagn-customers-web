<% if current_customer.errors.any? %>
  customAlert('Error!', "Please try again later")
<% else %>
  customAlert('Done!', "We've sent you a confirmation email")
<% end %>
