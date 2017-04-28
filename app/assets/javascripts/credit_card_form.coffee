$.onmount 'form#add_new_card, form#service-request-form', ->
  $(this).on 'submit', (event) ->
    $form = $(this)
    if $('.card-bg').is(':visible') || $('.add-card-wrapper').hasClass('show')
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
    $form = $('form#add_new_card, form#service-request-form')
    if response.error
      show_error response.error.message
      $('#add_card.modal .panel-body').find('p.error-block').remove()
      $('#add_card.modal .panel-body').prepend("<p class='error-block'>" + response.error.message + "</p>")
      $form.find('input[type=submit]').prop 'disabled', false
      $('.card-bg').find('input').prop('disabled', false)
    else
      token = response.id
      $form = $form.find('#service_request_token').val(token)
      $('.card-bg').find('input').prop('disabled', true)
      $('#add_card.modal .panel-body').find('p.error-block').remove()
      $form.submit()

  show_error = (message) ->
    $('#flash-messages').html '<div class="alert alert-warning"><a class="close" data-dismiss="alert">×</a><div id="flash_alert">' + message + '</div></div>'
    if !($('#flash-messages').is(':visible'))
      $('.content-wrapper').addClass('hidden')
      $('.content-wrapper.complete-request').removeClass('hidden')
    $('.alert').delay(5000).fadeOut 3000
    false
    
$(document).on 'keyup', 'input#card_number', ->
  card_type = Stripe.card.cardType($(this).val())
  if(card_type == 'Visa')
    $('span.visa').addClass('active')
    $('span.master_card').removeClass('active')
    $('span.american_express').removeClass('active')
    $('.card-image').removeClass('master-card-img')
    $('.card-image').removeClass('american-express-img')
    $('.card-image').addClass('visa-card-img')
  else if(card_type == 'MasterCard')
    $('span.visa').removeClass('active')
    $('span.master_card').addClass('active')
    $('span.american_express').removeClass('active')
    $('.card-image').addClass('master-card-img')
    $('.card-image').removeClass('american-express-img')
    $('.card-image').removeClass('visa-card-img')
  else if (card_type == 'American Express')
    $('span.visa').removeClass('active')
    $('span.master_card').removeClass('active')
    $('span.american_express').addClass('active')
    $('.card-image').removeClass('master-card-img')
    $('.card-image').addClass('american-express-img')
    $('.card-image').removeClass('visa-card-img')

