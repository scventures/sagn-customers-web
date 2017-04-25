(($) ->
  $.fn.extend
    bs_alert: (message, title) ->
      cls = 'alert-danger'
      html = '<div class="alert ' + cls + ' alert-dismissable"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>'
      if typeof title != 'undefined' and title != ''
        html += '<h4>' + title + '</h4>'
      html += '<span>' + message + '</span></div>'
      $(this).prepend html
      return
    bs_warning: (message, title) ->
      cls = 'alert-warning'
      html = '<div class="alert ' + cls + ' alert-dismissable"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>'
      if typeof title != 'undefined' and title != ''
        html += '<h4>' + title + '</h4>'
      html += '<span>' + message + '</span></div>'
      $(this).prepend html
      return
    bs_info: (message, title) ->
      cls = 'alert-info'
      html = '<div class="alert ' + cls + ' alert-dismissable"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>'
      if typeof title != 'undefined' and title != ''
        html += '<h4>' + title + '</h4>'
      html += '<span>' + message + '</span></div>'
      $(this).prepend html
      return
  return
) jQuery
