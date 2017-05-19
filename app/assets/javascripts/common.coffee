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
    img = new Image
    $(event.target).parents('.image-wrapper').find('.remove_fields').removeClass('hidden')
    $(event.target).parents('.image-wrapper').find('.image-upload-label').first().addClass('hidden')
    $(event.target).parents('.image-wrapper').find('.image-upload-label').last().removeClass('hidden').html $('<img>').attr(
      src: file.target.result
      class: 'img-preview')
    $(event.target).focusout()
  reader.readAsDataURL image

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
  
$(document).on 'ready shown.bs.modal load turbolinks:load turboboost:complete', ->
  $.onmount()

$.onmount '.select2', ->
  $(this).select2()
