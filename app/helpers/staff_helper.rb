module StaffHelper

  def role(role)
    if role == 'account_owner'
      'Owner'
    else
      'Staff'
    end
  end
  
end
