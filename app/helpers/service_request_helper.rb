module ServiceRequestHelper
  def service_request_button_add_fields(f, association)  
    new_object = IssueImage.new 
    fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|  
      render("issue_image_field", :f => builder)  
    end 
    button = "<button type='button' class='btn btn-primary ml20' onclick='add_field_for_images(this, \"#{association}\", \"#{escape_javascript(fields)}\")' formnovalidate data-loading-text='Loading...'>Add Photo</button>"
    button.html_safe
  end 
end
