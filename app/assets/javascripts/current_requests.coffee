$(document).on 'click', '#chooseCard .btn-close', ->
  if $('#chooseCard #choose_card').val() == 'add_new_card'
    $('#addCardForEstimate .pic-payment-methods, #add_card .pic-payment-methods').addClass('hidden')
    $('#addCardForEstimate .card-details, #add_card .card-details').removeClass('hidden')
  else
    $('#addCardForEstimate, .card-details').find('.alert .alert-success').remove()
    $('#addCardForEstimate .pic-payment-methods, #add_card .pic-payment-methods').prepend($('<p>').attr('class', 'alert alert-success').html('Default payment is selected please click on pay button.').append($('<button>').attr({'class': 'close', 'data-dismiss': 'alert'}).html('x')))
  $('#chooseCard').modal('hide')
  
$(document).on 'click', '#addCardForEstimate .btn-close, #add_card .btn-close', (e) ->
  e.preventDefault()
  if $(this).parents('.modal').find('.pic-payment-methods').hasClass('hidden')
    $(this).parents('.modal').find('.pic-payment-methods').removeClass('hidden')
    $(this).parents('.modal').find('.card-details').addClass('hidden')
    $(this).parents('.modal').find('.alert .alert-success').remove()
  else
    $('#addCardForEstimate').modal('hide')
    
$(document).on 'shown.bs.modal', '#addCardForEstimate, #add_card', ->
  $('this').find('.alert .alert-success').remove()
