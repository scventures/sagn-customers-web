$(document).on 'cocoon:after-insert', '.my-staff-form-wrapper form', ->
  if $(this).find('.nested-fields').length > 1
    $(this).find('.remove_fields').removeClass('hidden')
  else
    $(this).find('.remove_fields:first').addClass('hidden')

$(document).on 'cocoon:after-remove', '.my-staff-form-wrapper form', ->
  if $(this).find('.nested-fields').length == 1
    $(this).find('.remove_fields:first').addClass('hidden')
  else
    $(this).find('.remove_fields:first').removeClass('hidden')

$.onmount '.my-staff-form-wrapper form', ->
  if $(this).find('.nested-fields').length == 1
    $(this).find('.remove_fields:first').addClass('hidden')
