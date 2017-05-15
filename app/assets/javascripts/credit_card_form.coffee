card = ''  
$.onmount '.card-details', ->
  elements = stripe.elements()
  style = 
    base:
      color: '#32325d'
      lineHeight: '24px'
      fontFamily: '"Helvetica Neue", Helvetica, sans-serif'
      fontSmoothing: 'antialiased'
      fontSize: '16px'
      '::placeholder': color: '#aab7c4'
    invalid:
      color: '#fa755a'
      iconColor: '#fa755a'
  card = elements.create('card', style: style, hidePostalCode: true)
  card.mount '#card-element'
  card.addEventListener 'change', (event) ->
    displayError = document.getElementById('card-errors')
    if event.error
      displayError.textContent = event.error.message
    else
      displayError.textContent = ''
    return
  
$(document).on 'click', '.credit_card_button', (e) ->
  $('#payment-form').block
    message: '<i class="fa fa-spinner fa-spin fa-4x"></i>'
    css:
      border: 'none'
      background: 'none'
      color: '#808080'
    overlayCSS:
      backgroundColor: 'transparent'
      cursor: 'wait'
  form = $(this).parents('form:first')
  e.preventDefault()
  stripe.createToken(card).then (result) ->
    if result.error
      $('#payment-form').unblock()
      errorElement = document.getElementById('card-errors')
      errorElement.textContent = result.error.message
    else
      stripeTokenHandler result.token, form

stripeTokenHandler = (token, form) ->
  $('#payment-form').unblock()
  $(form).find('#service_request_token').val(token.id)
  if $(form).hasClass('service-request-logout-form')
    $('#wizard').steps('setStep', 11)
  else
    $(form).submit()
