$(document).on 'click', '.stars a.star', ->
  $('.customer-rating-input').val($('.rating-container input:checked').val())
