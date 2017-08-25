class Customers::ConfirmationsController < Devise::ConfirmationsController
  skip_before_filter :check_for_registration
end
