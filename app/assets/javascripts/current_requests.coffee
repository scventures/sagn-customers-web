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
