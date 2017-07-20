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

showServiceRequestDetails = (id) ->
  $('.current-request-wrapper, .past-request-wrapper').removeClass('selected')
  $(".current-request-wrapper#current-request-details-#{id}, .past-request-wrapper#past-request-details-#{id}").addClass('selected')
  $('.current-request-details, .past-request-details').html('')
  $('.current-request-details, .past-request-details').block blockUI
  
$(document).on 'click', '.current-request-list .details-link, .past-request-list .details-link', ->
  id = $(this).data('id')
  showServiceRequestDetails(id)
