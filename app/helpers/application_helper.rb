module ApplicationHelper
  
  def date_format(date)
    datetime = Time.zone.parse date
    datetime.strftime('%m/%d/%Y')
  end
  
  def time_format(date)
    datetime = Time.zone.parse date
    datetime.strftime('%I:%M %p')
  end 
  
  def flash_container(type, message, args={})
    raw(content_tag(:div, :class => "alert alert-#{type} #{args[:class]}") do
      content_tag(:a, raw("&times;"),:class => 'close', :data => {:dismiss => 'alert'}) +
      message
    end)
  end

  def difference_in_minutes(t1, t2)
    ((t1 - t2) / 1.minutes).to_i
  end
  
end
