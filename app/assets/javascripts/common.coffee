$(document).on 'ajax:beforeSend', 'a.with-ajax-loader', (e)->
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

$.onmount '.image-upload', ->
  $(this).on 'change', (event) ->
    files = event.target.files
    image = files[0]
    reader = new FileReader
    reader.onload = (file) ->
      img = new Image
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

$(document).on 'turbolinks:load', ->
  $('.ps-scroll').perfectScrollbar()

$(document).on 'click', '[data-toggle=offcanvas]', ->
  $('.row-offcanvas').toggleClass('active')

$(document).on 'ready shown.bs.modal load turbolinks:load turboboost:complete', ->
  $.onmount()

