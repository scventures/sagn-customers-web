module ApplicationHelper
  
  def date_format(date)
    datetime = Date.parse date
    datetime.strftime('%m/%d/%Y')
  end
  
  def time_format(date)
    datetime = DateTime.parse date
    datetime.getlocal.strftime('%I:%M %p')
  end 
  
  def flash_container(type, message, args={})
    raw(content_tag(:div, :class => "alert alert-#{type} #{args[:class]}") do
      content_tag(:a, raw("&times;"),:class => 'close', :data => {:dismiss => 'alert'}) +
      message
    end)
  end 
  
end
