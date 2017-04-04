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

$(document).on 'ready, turbolinks:load', ->
  $('ul li.nav-header').find('h1').html($('.header-title').html())
  
$('.image-upload').livequery ->
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

$('form[data-client-side-validations][data-turboboost]').livequery ->
  $(this).enableClientSideValidations()
  
$(document).on 'shown.bs.modal', '.modal', ->
  $('form').enableClientSideValidations()
