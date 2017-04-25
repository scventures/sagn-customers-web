$('form#add_new_card').livequery ->
  $('form#add_new_card').on 'submit', (event) ->
    $form = $(this)
    if($form.find('#service_request_token').val().length == 0)
      $form.find('input[type=submit]').prop 'disabled', true
      Stripe.card.validateCVC($('[data-stripe=cvv]').val())
      Stripe.card.createToken {
        number: $('[data-stripe=number]').val()
        cvc: $('[data-stripe=cvv]').val()
        exp_month: $('[data-stripe=exp-month]').val()
        exp_year: $('[data-stripe=exp-year]').val() }, stripeResponseHandler
      false

  stripeResponseHandler = (status, response) ->
    $form = $('form#add_new_card')
    if response.error
      show_error response.error.message
      $form.find('input[type=submit]').prop 'disabled', false
    else
      token = response.id
      $form = $('form#add_new_card').find('#service_request_token').val(token)
      $form.submit()
    false

  show_error = (message) ->
    $('#flash-messages').html '<div class="alert alert-warning"><a class="close" data-dismiss="alert">×</a><div id="flash_alert">' + message + '</div></div>'
    $('.alert').delay(5000).fadeOut 3000
    false
    
$(document).on 'keyup', 'input#card_number', ->
  card_type = Stripe.card.cardType($(this).val())
  alert(card_type)
  if(card_type == 'Visa')
    $('a.visa').addClass('active')
    $('a.master_card').removeClass('active')
    $('a.american_express').removeClass('active')
    $('.card-image').removeClass('master-card-img')
    $('.card-image').removeClass('american-express-img')
    $('.card-image').addClass('visa-card-img')
  else if(card_type == 'MasterCard')
    $('a.visa').removeClass('active')
    $('a.master_card').addClass('active')
    $('a.american_express').removeClass('active')
  else if (card_type == 'American Express')
    $('a.visa').removeClass('active')
    $('a.master_card').removeClass('active')
    $('a.american_express').addClass('active')

