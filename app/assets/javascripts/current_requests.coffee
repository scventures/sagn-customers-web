$(document).on 'click', '#chooseCard .btn-close', ->
  if $('#chooseCard #choose_card').val() == 'add_new_card'
    $('#addCardForEstimate .default-payment-container, #add_card .default-payment-container').addClass('hidden')
    $('#addCardForEstimate .card-details, #add_card .card-details').removeClass('hidden')
    $('.pic-payment-methods a').html('Add new card')
  else
    $('#addCardForEstimate .default-payment-container, #add_card .default-payment-container').removeClass('hidden')
    $('#addCardForEstimate .card-details, #add_card .card-details').addClass('hidden')
    $('.pic-payment-methods a').html('Default payment method')
    $('#addCardForEstimate .card-details, #add_card .card-details').find('#service_request_token').val('')
  $('#chooseCard').modal('hide')
  
$(document).on 'click', '#addCardForEstimate .btn-close, #add_card .btn-close', (e) ->
  e.preventDefault()
  $(this).parents('.modal').modal('hide')
    
$(document).on 'click', '#declineAssignment .select_reason', ->
  $('#declineAssignment').find('.form-group.radio_buttons').addClass('hidden')
  $('#declineAssignment').find('.search-new-technician').removeClass('hidden')

$(document).on 'turbolinks:request-end', (e) ->
  if e.originalEvent.data.xhr.responseURL.match(/\/current_requests/i)
    serviceRequestId = e.originalEvent.data.xhr.getResponseHeader('SERVICE_REQUEST_ID')
    if serviceRequestId?
      $(document).one 'turbolinks:render', (event) =>
        showServiceRequestCreationAlert()

showServiceRequestCreationAlert = () ->
  customAlert('Service Request Received!', 'We\'re searching for the right technician.')

currentRequestListScrollTop = () ->
  scrollHeight = $('.current-request-wrapper.selected').position().top
  $('.current-request-list').scrollTop(scrollHeight)

$(document).on 'click', '.current-request-list .details-link', (e) ->
  e.preventDefault()
  loadServiceRequestDetails($(this).data('id'))
  
window.loadServiceRequestDetails = (id) ->
  $.ajax
    type: 'GET'
    dataType: 'HTML'
    url: Routes.current_request_path(id)
    beforeSend:  (xhr, settings) ->
      $('.current-request-wrapper').removeClass('selected')
      $(".current-request-wrapper#current-request-details-#{id}").addClass('selected')
      $('.current-request-details').html('')
      $('.current-request-details').block blockUI
    success: (data) ->
      $('#current-request-details-wrapper').html(data)
    complete: ->
      $('.current-request-details').unblock()

$.onmount '#current_requests_show', ->
  currentRequestListScrollTop()
