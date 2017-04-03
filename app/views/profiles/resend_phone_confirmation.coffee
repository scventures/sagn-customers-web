<% if current_customer.errors.any? %>
  customAlert('Error!', "Please try again later")
<% else %>
  customAlert('New Code Sent!', "We've sent you a text message with a new code to the number you provided.")
<% end %>
