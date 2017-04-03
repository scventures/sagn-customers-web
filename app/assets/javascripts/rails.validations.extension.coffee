attachment_size_validation = (element, options) ->
  if element[0].files and element[0].files[0] and element[0].files[0].size >= options.less_than_or_equal_to
    return options.message
  return

attachment_content_type_validation = (element, options) ->
  if element[0].files and element[0].files[0]
    for i of options.allow
      rule = options.allow[i]
      re = new RegExp(rule.source or rule, rule.options)
      if re.test(element[0].files[0].type)
        return false
    $(element).parents('.image-wrapper').find('.image-upload-label').last().addClass('hidden')
    $(element).parents('.image-wrapper').find('.image-upload-label').first().removeClass('hidden')
    return options.message
  return

document.addEventListener 'turbolinks:load', ->
  window.ClientSideValidations.validators.local.file_size = attachment_size_validation
  window.ClientSideValidations.validators.local.file_content_type = attachment_content_type_validation
  return
