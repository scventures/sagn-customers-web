$(document).on 'cocoon:after-insert', '.issue-image-wrapper', (e, addedIssueImage) ->
  $(addedIssueImage).closest('form').enableClientSideValidations()
  
$(document).on 'change', '.radio-btn input[type="radio"]', ->
  if $(this).val() == 'send_a_guy'
    $('.select-guy').removeClass 'hidden'
    $('.select-guy select').prop 'disabled', false
  else
    $('.select-guy').addClass 'hidden'
    $('.select-guy select').prop 'disabled', true
    
$(document).on 'click', '.current-request-list .details-link, .past-request-list .details-link', ->
  $('.current-request-wrapper, .past-request-wrapper').removeClass('selected')
  $(this).find('.current-request-wrapper, .past-request-wrapper').addClass('selected')
  $('.current-request-details, .past-request-details').html('')
  $('.current-request-details, .past-request-details').block blockUI

blockUI =
  message: '<i class="fa fa-spinner fa-pulse fa-4x"></i>'
  css:
    border: 'none'
    background: 'none'
    color: '#808080'
  overlayCSS:
    backgroundColor: 'transparent'
    cursor: 'wait'
        
setMarkers = (map) ->
  infowindow = new google.maps.InfoWindow()
  bounds = new google.maps.LatLngBounds()
  @markers = {}
  $.ajax
    url: Routes.locations_path()
    type: 'GET'
    dataType: 'JSON'
    success: (data) ->
      last_marker = data[data.length - 1]
      markers_length =  data.length
      $.each data, (i, location) ->
        markerLatLng = new google.maps.LatLng location.geography.latitude, location.geography.longitude
        marker = new google.maps.Marker
          position: { lat: location.geography.latitude, lng: location.geography.longitude }
          map: map
        markers[location.id] = marker
        google.maps.event.addListener marker, 'click', do (marker, i) ->
          ->
            content = "<div class='info-window'><h4>#{location.name}</h4><a href=#{Routes.new_location_service_request_path(location_id: location.id)} class='btn btn-red btn-lg'>SendaGuy to this location</a></div>"
            infowindow.setContent content
            infowindow.open map, marker
            return
        bounds.extend markerLatLng
      unless bounds.isEmpty()
        map.fitBounds bounds
        if markers_length == 1
          map.setZoom 10
      google.maps.event.trigger(markers[last_marker.id], 'click');
  
initMap = ->
  if document.getElementById('google-map')
    map = new google.maps.Map document.getElementById('google-map'),
      minZoom: 1
      maxZoom: 21
      zoom: 4
      center: new google.maps.LatLng 37.09024, -95.712891
      mapTypeId: google.maps.MapTypeId.ROADMAP
    setMarkers(map)

$.onmount '#google-map', ->
  initMap()

$(document).on 'click', '.map-container a.location-link, .location-images-container a.location-link', (e) ->
  e.preventDefault()
  id = $(this).data('id')
  google.maps.event.trigger markers[id], 'click'
  if $(this).data('collapse')
    $('.map-container').find('button.location-btn').trigger('click')

unmarkSubSteps = (indices = []) ->
  currentSubSteps = $('#wizard .steps ul li[aria-substep]').map ()->
    return $(this).index()
  markSubSteps(currentSubSteps.not(indices).toArray())

markSubSteps = (indices = []) ->
  if $('#service-request-form').hasClass('service-request-logout-form')
    subStepIndices = indices.concat([1, 4, 5, 6, 7, 9, 10])
  else
    subStepIndices = indices.concat([1, 4, 5, 6, 8])
  steps = $('#wizard .steps ul li')
  subSteps = steps.filter(':eq(' + subStepIndices.join('), :eq(') + ')')
  parentSteps = steps.not subSteps
  parentSteps.removeAttr 'aria-substep'
  subSteps.attr 'aria-substep', true
  parentSteps.css
    width: "#{100 / parentSteps.length}%"


$.onmount '#wizard' , ->
  $(this).steps
    headerTag: 'h2'
    bodyTag: 'section'
    transitionEffect: 'slideLeft'
    enableKeyNavigation: false
    autoFocus: false
    titleTemplate: '<div class="number step-#index#"><div class="line line-left"></div><div class="line line-right"></div><div class="icon"></div><div class="title">#title#</div><div class="summary-data grey"></div></div>'
    onInit: ->
      $('#wizard > .steps').appendTo '#wizard'
      markSubSteps()
      return
    onStepChanging: (event, currentIndex, newIndex) ->
      title = $('#wizard').steps('getStep', currentIndex).title
      if title == 'Summary &amp; Payment'
        $('.service-request-logout-form p.title').addClass('hidden')
      else
        $('.service-request-logout-form p.title').removeClass('hidden')
      form = $(this).parents('form:first')
      valid = true
      if newIndex > currentIndex
        $.each $("#wizard-p-#{currentIndex} .content-wrapper:not(.card-details)").find("select"), (i, element) ->
          unless $(element).hasClass('venue_name')
            valid = $(element).isValid(form[0].ClientSideValidations.settings.validators) and valid
          return
      return valid
    onStepChanged: (event, currentIndex, priorIndex) ->
      li = $("#wizard-t-#{priorIndex}").parent()
      if currentIndex == 1 and $('.subcategories-wrapper .subcategory_field').val() == ''
        $("#wizard-p-#{currentIndex}").find('.next-btn').addClass('hidden')
      if li.hasClass('done') and !li.attr('aria-done')
        li.attr 'aria-done', true
        $("#wizard-p-#{priorIndex}").find('.next-btn').removeClass('hidden')
      $("#wizard-p-#{currentIndex} .content-wrapper:not(.card-details)").find('input, select').enableClientSideValidations()
      switch $('#wizard').steps('getStep', priorIndex).title
        when 'Service Request'
          category = $('#service-request-form .category-wrapper input[type=radio]:checked').prev().find('p').html()
          $('.steps #wizard-t-0 .summary-data').html(category)
        when 'Sub Category'
          category = $('#service-request-form .category-wrapper input[type=radio]:checked').prev().find('p').html()
          subcategory = $('#service-request-form .subcategories-wrapper input[type=radio]:checked').parent().find('p').html()
          $('.steps #wizard-t-0 .summary-data').html([category, subcategory].join(' / '))
          $('.summary-details-wrapper').find('.category').html("#{category} #{subcategory}")
        when 'Specific issue'
          $('.steps #wizard-t-2 .summary-data').html()
        when 'Order Details'
          model = $('input.service_request_model').val()
          brand_name = $('#service_request_brand_name').val()
          serial = $('input.service_request_serial').val()
          data = $.grep([brand_name, model], Boolean).join(' ')
          data = $.grep([data, serial], Boolean).join(' - ')
          $('.steps #wizard-t-3 .summary-data').html(data)
          $('.summary-details-wrapper').find('.brand').html(data)
        when 'Schedule'
          if $('.urgent-service').val() == 'Yes'
            if $('.steps #wizard-t-3 .summary-data').html().length == 0
              $('.steps #wizard-t-3 .summary-data').html('Urgent Request')
            else
              $('.steps #wizard-t-3 .summary-data').append(', Urgent Request')
        when 'Restaurant Details'
          location = $('#service-request-form .location_name').val() || $('#service-request-form .location_address').val()
          $('.summary-details-wrapper').find('.location').html(location)
          $('.steps #wizard-t-8 .summary-data').html(location)
        when 'Issue Image'
          setSummaryDetailsImages()
          $('.summary-details-wrapper').find('.location').html($('#service-request-form .location_name').val())
          if !$('.steps #wizard-t-7').parents('li:first').hasClass('disabled')
            images = $('.provide-photo-img').find('img').length
            $('.steps #wizard-t-7 .summary-data').html("#{images} Issue Image(s)")
      $.onmount()
      updatePerfectScroll('#wizard > .content', true)
      return
      
setSubcategoriesImages = (id) ->
  $('.subcategory_icons').addClass('hidden')
  $(".subcategory_icons.category-#{id}").removeClass('hidden')
  $(".subcategory_icons.category-#{id} img").each ->
    imgSrc = $(this).data('src')
    $(this).attr('src', imgSrc)
  $('.subcategories-wrapper .subcategory_field').val('')
  $('#wizard').steps('next')
  
setEquipment = ->
  location_id = $('#service_request_location_id').val()
  subcategory_id = $('.subcategories-wrapper .subcategory_field').val()
  if location_id?
    $.ajax
      url: Routes.location_equipment_items_path(location_id: location_id, subcategory_id: subcategory_id)
      type: 'GET'
      dataType: 'json'
      success: (data) ->
        $('form:visible').unblock()
        if data.length > 0
          data.map((obj) -> (obj.text = obj.text or obj.subcategory.name))
          $('.equipment-field-wrapper').removeClass('hidden')
          $('.select_equipment').empty()
          $('.select_equipment').select2
            placeholder: 'Please select Equipment'
            data: data
  
$(document).on 'change, click', '.category-wrapper input[type=radio]', ->
  setSubcategoriesImages($(this).val())
  
$(document).on 'change, click', '.subcategories-wrapper input[type=radio]', ->
  $('.subcategories-wrapper .subcategory_field').val($(this).val())
  brands = $(this).data('brands')
  problem_codes = $(this).data('problem-codes')
  $('.equipment_wrapper').addClass('hidden')
  $('.equipment-field-wrapper').addClass('hidden')
  if $(this).data('equipment')
    $('.equipment_wrapper').removeClass('hidden')
    if !($('form:visible').hasClass('service-request-logout-form'))
      $('form:visible').block blockUI
      setEquipment()
  else
    $('a.problem-details-link').attr('data-equipment', true)
  brands.map((obj) -> (obj.text = obj.text or obj.name))
  if brands.length > 0
    $('#service_request_brand_name').addClass('hidden')
    $('#service_request_brand_name').val(brands[0].name)
  $('.select_brand').empty()
  $('.select_brand').select2
    placeholder: 'Please select Brand'
    data: brands
  if brands.length == 0
    $('#service_request_brand_name').removeClass('hidden')
  category = $('#service-request-form .category-wrapper input[type=radio]:checked').prev().find('p').html()
  if category == 'Preventive Maintenance'
    $('#wizard').steps('setStep', 6)
    $('#wizard #wizard-p-1 .next-btn').data('step', 6)
    $('#wizard #wizard-p-6 .back-btn').data('step', 1)
    $('.preventative-maintenance-contact').prop('disabled', false)
  else
    $('#wizard #wizard-p-5 .request-continue-btn').data('step', 7)
    $('#wizard #wizard-p-5 .next-btn').data('step', 7)
    $('#wizard #wizard-p-7 .back-btn').data('step', 5)
    if problem_codes.length > 0
      unmarkSubSteps([2])
      problem_codes.map((obj) -> (obj.text = obj.text or obj.name))
      $('.select_problem_code').empty()
      $('.select_problem_code').select2
        data: problem_codes
      $('#wizard').steps('next');
      $('#wizard #wizard-p-3 .back-btn, #wizard #wizard-p-4 .back-btn').removeData('step')
    else
      markSubSteps([2])
      if $(this).data('equipment')
        $('#wizard').steps('setStep', 3)
        $('#wizard #wizard-p-1 .next-btn').data('step', 3)
        $('#wizard #wizard-p-3 .back-btn').data('step', 1)
      else
        $('#wizard').steps('setStep', 4)
        $('#wizard #wizard-p-1 .next-btn').data('step', 4)
        $('#wizard #wizard-p-4 .back-btn').data('step', 1)
      
$(document).on 'select2:select', '.select_brand', (e)  ->
  $('#service_request_brand_name').val(e.params.data.text)
      
$(document).on 'select2:select', '.service-request-form-wrapper .select_equipment', (e) ->
  $('#service_request_brand_name').val(e.brand_name)
  $('#service_request_model').val(e.model)
  $('#service_request_serial').val(e.serial)
        
$(document).on 'click', '.service-request-form-wrapper .content-wrapper .back-btn', (e) ->
  e.preventDefault()
  if stepNumber = $(this).data('step')
    $('#wizard').steps('setStep', stepNumber);
  else
    $('#wizard').steps('previous');
    
$(document).on 'click', '.service-request-form-wrapper .content-wrapper .next-btn, .service-request-form-wrapper .request-continue-btn',  (e) ->
  e.preventDefault()
  if stepNumber = $(this).data('step')
    $('#wizard').steps('setStep', stepNumber);
  else
    $('#wizard').steps('next');
  

$(document).on 'click', '.service-request-form-wrapper .request-service-card-btn', (e) ->
  e.preventDefault()
  if $(this).data('card') == 'add'
    $('.service-request-form-wrapper #payment-form').removeClass('hidden')
    $('.service-request-form-wrapper .service-request-submit-btn').addClass('hidden')
  else
    $('.service-request-form-wrapper #payment-form').addClass('hidden')
    $('.service-request-form-wrapper .service-request-submit-btn').removeClass('hidden')
  
setCategories = ->
  if $('.select_category option:selected').val() != ''
    categories = $('.select_category option:selected').data('categories')
    categories.map((obj) -> (obj.text = obj.text or obj.name))
    $('.select_subcategory').empty()
    categories.unshift({id: 'prompt', text: 'Please select category'})
    $('.select_subcategory').select2
      data: categories
    $('.select_brand').empty()

$(document).on 'select2:select, change', '.select_category', (e) ->
  setCategories()
  
setBrands = (e) ->
  if $('.select_subcategory option:selected').val() != ''
    if e.params.data.brands
      brands = e.params.data.brands
    else
      brands = $('.select_subcategory option:selected').data('brands')
    brands.map((obj) -> (obj.text = obj.text or obj.name))
    $('.select_brand').empty()
    brands.unshift({id: 'prompt', text: 'Please select brand'})
    $('.select_brand').select2
      data: brands

$(document).on 'select2:select', '.select_subcategory', (e) ->
  setBrands(e)
  
$.onmount 'form#service-request-form', (e) ->
  if $(this).find('.has-error').length > 0
    section_id = $(this).find('.has-error').first().parents('section').attr('id')
    stepNumber = section_id.split('-')[2]
    $('#wizard').steps('setStep', stepNumber);
    $('.steps li').addClass('done')
  
$(document).on 'click', '.left-sidebar ul li a.past-requests-link', (e) ->
  e.preventDefault()

$(document).on 'keyup', '.us_phone_number', ->
  phone_number = $(this).val()
  if isValidNumber(phone_number.replace(/ /g, ''), 'US')
    phone_number = formatNumberForMobileDialing('US', phone_number)
    $(this).val(phone_number)

$(document).on 'change', '.urgent-service', ->
  if $(this).val() == 'Yes'
    $('.urgent-wrapper').find('h5').html('Please indicate any times within the next 4-6 hours that are NOT good for you to have a technician arrive.')
    $('.urgent-wrapper').find('textarea').attr('placeholder', '')
  else
    $('.urgent-wrapper').find('h5').html('When would you like a technician to arrive?')
    $('.urgent-wrapper').find('textarea').attr('placeholder', 'Please be specific. For example: Any time next week, Tuesday afternoon, Friday morning, etc.')
    
$(document).on 'cocoon:after-insert', '.provide-photo', (e) ->
  $(this).find('.image-upload:last').trigger('click')
  
$(document).on 'click', '.details-change-link', (e) ->
  e.preventDefault()
  $('#wizard').steps('setStep', $(this).data('step'));
  
setSummaryDetailsImages = ->
  $('.summary-details-wrapper').find('.issue_image').html('')
  images = $('.provide-photo-img').find('img').map(->
    $(this).attr 'src'
  ).get()
  $.each images, (i, img) ->
    $('.summary-details-wrapper').find('.issue_image').append($('<img>').attr(src: img, class: 'preview'))
    
$(document).on 'click', '.service-request-signin-link', (e) ->
  e.preventDefault()
  form = $(this).parents('form:first')
  $(form).attr('action', Routes.customers_create_serivce_request_with_login_path())
  $('.signup-header').addClass('hidden')
  $('.signin-header').removeClass('hidden')
  $('.sign-up-fields').addClass('hidden').find('input').prop('disabled', true)
  $('.sign-in-fields').removeClass('hidden').find('input').prop('disabled', false)
  $(form).resetClientSideValidations()

$(document).on 'click', '.service-request-signup-link', (e) ->
  e.preventDefault()
  form = $(this).parents('form:first')
  $(form).attr('action', Routes.customers_create_with_service_request_path())
  $('.signup-header').removeClass('hidden')
  $('.signin-header').addClass('hidden')
  $('.sign-up-fields').removeClass('hidden').find('input').prop('disabled', false)
  $('.sign-in-fields').addClass('hidden').find('input').prop('disabled', true)
  $(form).resetClientSideValidations()
  
$(document).on 'keypress', 'form#service-request-form', (e) ->
  if e.which != 13
    return
  e.preventDefault()

$.onmount '.location-container', ->
  $this = $(this)
  $(this).block
    message: '<i class="fa fa-spinner fa-pulse fa-4x"></i>'
    css:
      border: 'none'
      background: 'none'
      color: '#808080'
    overlayCSS:
      backgroundColor: 'transparent'
      cursor: 'wait'
  venue_id = $(this).data('venue-id')
  id = $(this).data('location-id')
  lng = $(this).data('lng')
  lat = $(this).data('lat')
  if venue_id
    $.ajax
      url: Routes.images_venue_path(venue_id)
      type: 'GET'
      dataType: 'JSON'
      success: (data) -> 
        $this.unblock()
        if data.count == 1
          img_src = "#{data.items[0].prefix}500x500#{data.items[0].suffix}"
          $this.find('.images-container').html($('<img>').attr({'src': img_src}))
        else
          locationStreetView(lat, lng, id)
  else
    $(this).unblock()
    locationStreetView(lat, lng, id)
    
$.onmount '.service-request-edit-form .select2:visible', ->
  $(this).select2()

$(document).on 'click', '.decline-estimate-link', (e)->
  e.preventDefault()
  $('#declineEstimate .message').addClass('hidden')
  $('#declineEstimate .decline-reason').removeClass('hidden')
