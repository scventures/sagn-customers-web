$(document).on 'click', '.stars a.star', ->
  $('.customer-rating-input').val($('.rating-container input:checked').val())
  
showServiceRequestDetails = (id) ->
  $('.past-request-wrapper').removeClass('selected')
  $(".past-request-wrapper#past-request-details-#{id}").addClass('selected')
  $('.past-request-details').html('')
  $('.past-request-details').block blockUI
  
$(document).on 'click', '.past-request-list .details-link', ->
  id = $(this).data('id')
  showServiceRequestDetails(id)
