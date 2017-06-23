module ServiceRequestHelper
  def category_icons(resource, load_image = false)
    image_url = resource.image_url? ? resource.image_url : 'default_category.png'
    image = if load_image
        image_tag(image_url, width: '200', height: '200')
      else
        image_tag('', width: '200', height: '200', data: { src: asset_path(image_url) })
      end
    content_tag :div, class: 'center' do
      image +
      content_tag(:p, resource.name )
    end
  end
  
  def cents_to_money(cents)
    Money.new(cents)
  end

  def time_remaining_to_approve(minutes)
    if minutes > 1
      "You have #{minutes} minutes left to approve this estimate"
    elsif minutes == 1
      "You have #{minutes} minute left to approve this estimate"    
    elsif minutes == 0
      "You have less than a minute to approve this estimate"
    end
  end

  def estimation_notice(estimation)
    minutes_to_accept = 30
    created_at = Time.zone.parse estimation[:created_at]
    content_tag :div do
      if estimation[:fix_right_now]
        miutes_passed = minutes_to_accept - difference_in_minutes(Time.now, created_at) 
        if miutes_passed <= minutes_to_accept && miutes_passed >= 0
          concat( content_tag :h3, time_remaining_to_approve(miutes_passed), class: 'text-center red')
          concat( content_tag :h3, 'This estimate is for the additional work needed to complete your job.', class: 'mt10')
          concat( content_tag :p, 'This can be fixed today by the technician currently on site and this is the estimate to complete the fix. If you don\'t approve in time, there may be added cost for the technician to return.', class: 'mt10 fs16')
        elsif miutes_passed < 0
          concat( content_tag :h3, "You did not approve this estimate within #{minutes_to_accept} minutes.", class: 'text-center red')
          concat( content_tag :h3, 'This estimate is for the additional work needed to complete your job.', class: 'mt10')
          concat( content_tag :p, 'You can still accept this estimate, but the technician will likely provide a revised estimate including the cost for them to return to you location', class: 'mt10 fs16')
        end
      else
        concat(content_tag :p, "Estimate valid for 30 days. The technician will schedule a return visit to complete the work.", class: 'mt10 fs16')
        concat( content_tag :h3, 'This estimate is for the additional work needed to complete your job.', class: 'mt10')
      end
    end    
  end
  
  def contractor_estimation_text(assignment)
    content_tag :p do
      concat(assignment[:contractor_account][:name])
      if assignment[:revised_estimation]
        concat(" has revised your estimate. (Previous estimate was #{assignment[:revised_estimation][:total_estimate]}" )
      else
        concat(" has provided the following estimate")
      end
    end
  end

  def eta_text(eta)
    case eta
    when 'need_to_schedule'
      'To be scheduled after you accept'
    when 'today'
      'Can come today'
    when 'tomorrow'
      'Can come tomorrow'
    end
  end

  def payment_summary_text(assignment)
    if assignment.charging?
      "You must authorize a charge of #{(assignment.diagnostic_fee).format}"
    elsif total == 0
      'There will be no charge to you for this technician to arrive.'
    elsif assignment.remaining_promo_code_discount_cents > 0
      "There will be no charge to you for this technician to arrive and you have #{(assignment.remaining_promo_code_discount_cents).format} credit toward any further work for this service request."
    end
  end

  def cover_text(assignment)
    if assignment.charging?
      'This covers the technician\'s arrival and one hour of work to fix or diagnose the problem. Once you accept this contractor you cannot cancel and your card will be charged when the technician arrives.'
    else
      'If you accept, when the technician arrives, they will provide an estimate of the work to fix the problem.'
    end
  end

end
