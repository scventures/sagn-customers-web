Array::compact = ->
  (elem for elem in this when elem?)

$.fn.steps.setStep = (step) ->
  wizard = $('#wizard')
  index = $(wizard).data('state').currentIndex
  currentTransitionEffect = wizard.data('options').transitionEffect
  i = 0
  $.fn.steps.transitionEffect = 0
  while i < Math.abs(step - index)
    #disable transition effect for intermediate steps
    wizard.data('options').transitionEffect = if i == (Math.abs(step - index) - 1) then currentTransitionEffect else 0
    if step > index
      $(wizard).steps 'next'
    else
      $(wizard).steps 'previous'
    i++
  return

$(document).on 'ajax:beforeSend', 'a.with-ajax-loader', (e)->
  $(this).find('i.loader').remove()
  $(this).append($('<i>').addClass('fa fa-spinner fa-pulse loader ml10'))

$(document).on 'ajax:complete', 'a.with-ajax-loader', (e)->
  $(this).find('i.loader').remove()

$(document).on 'hidden.bs.modal', '.modal', (e)->
  if $('.modal.in').length
    $('body').addClass('modal-open')

window.customAlert = (title, message) ->
  dataConfirmModal.confirm
    title: title
    text: message
    commit: 'Ok'
    cancelClass: 'hide'
    zIindex: 10099

$(document).on 'change', '.image-upload', (event) ->
  $(event.target).parents('.image-wrapper').find('.remove_fields dynamic').removeClass('hidden')
  files = event.target.files
  image = files[0]
  reader = new FileReader
  reader.onload = (file) ->
    form = $(event.target).parents('form:first')
    $(event.target).parents('.image-wrapper').find('.remove_fields').removeClass('hidden')
    if $('form').data('client-side-validations') and !($(event.target).isValid($(event.target).parents('form:first')[0].ClientSideValidations.settings.validators))
      $(event.target).parents('.image-wrapper').find('.image-upload-label').last().html('')
      $(event.target).parents('.image-wrapper').find('.form-group.has-error').addClass('image-not-allowed')
    else
      $(event.target).parents('.image-wrapper').find('.form-group').removeClass('image-not-allowed')
      img = new Image
      $(event.target).parents('.image-wrapper').find('.image-upload-label').first().addClass('hidden')
      $(event.target).parents('.image-wrapper').find('.image-upload-label').last().removeClass('hidden').html $('<img>').attr(
        src: file.target.result
        class: 'img-preview img-responsive')
      $(event.target).focusout()
    form.trigger('image:loaded')
  reader.readAsDataURL image

$(document).on 'image:loaded', 'form', (e) ->
  updatePerfectScroll $(this).find('.ps-container')

$.onmount 'form[data-client-side-validations][data-turboboost]', ->
  $(this).enableClientSideValidations()
  
$(document).on 'shown.bs.modal', '.modal', ->
  $('form').enableClientSideValidations()

$.onmount '.ps-scroll, #wizard > .content', ->
  $(this).perfectScrollbar()

window.updatePerfectScroll = (container, resetScroll) ->
  if resetScroll
    $(container).scrollTop(0)
  $(container).perfectScrollbar('update')

$(document).on 'click', '[data-toggle=offcanvas]', ->
  $('.row-offcanvas').toggleClass('active')

$.onmount '.rating-container', ->
  $(this).rating()
  
$(document).on 'turbolinks:load shown.bs.modal load turboboost:complete', (e) ->
  $.onmount()
  
$(document).on "turboboost:error", (e, errors) ->
  form = $(e.target)
  if form.hasClass('service-request-logout-form') or form.hasClass('service-request-loggedin-form')
    form.clear_form_errors()
    errors = JSON.parse(errors)
    $.each(errors, (field, messages) ->
      input = form.find('input, select, textarea').filter(->
        name = $(this).attr('name')
        if name
          name.match(new RegExp('customer' + '\\[' + field + '\\(?'))
      )
      form[0].ClientSideValidations.addError(input, messages)
    )
  if form.find('.has-error').length > 0
    section_id = $(this).find('.has-error').first().parents('section').attr('id')
    stepNumber = section_id.split('-')[2]
    $('#wizard').steps('setStep', stepNumber);
    $('.steps li').addClass('done')
  
$.fn.clear_form_errors = () ->
  this.find('.form-group').removeClass('has-error')
  this.find('span.help-block').remove()
