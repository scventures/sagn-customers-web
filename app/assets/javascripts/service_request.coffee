$(document).on 'cocoon:after-insert', '.issue-image-wrapper', (e, addedIssueImage) ->
  $(addedIssueImage).closest('form').enableClientSideValidations()
  
$(document).on 'change', '.radio-btn input[type="radio"]', ->
  if $(this).val() == 'send_a_guy'
    $('.select-guy').removeClass 'hidden'
    $('.select-guy select').prop 'disabled', false
  else
    $('.select-guy').addClass 'hidden'
    $('.select-guy select').prop 'disabled', true
    
$(document).on 'click', '.current-request-list .details-link', ->
  $('.current-request-wrapper').removeClass('selected')
  $(this).find('.current-request-wrapper').addClass('selected')
  $('.current-request-details').html('')
  $('.current-request-details').block
      message: '<i class="fa fa-spinner fa-spin fa-4x"></i>'
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
      $.each data, (i, location) ->
        markerLatLng = new google.maps.LatLng location.geography.latitude, location.geography.longitude
        marker = new google.maps.Marker
          position: { lat: location.geography.latitude, lng: location.geography.longitude }
          map: map
        markers[location.id] = marker
        google.maps.event.addListener marker, 'click', do (marker, i) ->
          ->
            content = "<div><h3>#{location.name}</h3><a href=#{Routes.new_location_service_request_path(location_id: location.id)} class='btn btn-red btn-lg'>SendaGuy to this location</a></div>"
            infowindow.setContent content
            infowindow.open map, marker
            return
        bounds.extend markerLatLng
      unless bounds.isEmpty()
        map.fitBounds bounds
        if bounds.length == 1
          map.setZoom 10
  
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

$(document).on 'click', '.map-container a.location-link', (e) ->
  e.preventDefault()
  id = $(this).data('id')
  google.maps.event.trigger markers[id], 'click'
  $('.map-container').find('button.location-btn').trigger('click')

$.onmount '#wizard' , ->
  $(this).steps
    headerTag: 'h2'
    bodyTag: 'section'
    transitionEffect: 'slideLeft'
    enableKeyNavigation: false
    titleTemplate: '<div class="number step-#index#"><div class="line line-left"></div><div class="line line-right"></div><div class="icon"></div><div class="title">#title#</div><div class="summary-data grey"></div></div>'
    onInit: ->
      $('#wizard > .steps').appendTo '#wizard'
      if $('#service-request-form').hasClass('service-request-logout-form')
        $.each [1, 4, 5, 6, 8, 9], ->
          $('#wizard-t-' + this).parent().attr 'aria-substep', true
          return
      else
        $.each [1, 4, 5, 8], ->
          $('#wizard-t-' + this).parent().attr 'aria-substep', true
          return
      return
    onStepChanging: (event, currentIndex, newIndex) ->
      form = $(this).parents('form:first')
      valid = true
      if newIndex > currentIndex
        $.each $("#wizard-p-#{currentIndex} .content-wrapper:not(.card-details)").find("input, select"), (i, element) ->
          valid = $(element).isValid(form[0].ClientSideValidations.settings.validators) and valid
          return
      return valid
    onStepChanged: (event, currentIndex, priorIndex) ->
      li = $("#wizard-t-#{priorIndex}").parent()
      if li.hasClass('done') and !li.attr('aria-done')
        li.attr 'aria-done', true
        $("#wizard-p-#{priorIndex}").find('#next-btn').removeClass('hidden')
      $("#wizard-p-#{currentIndex} .content-wrapper:not(.card-details)").find('input, select').enableClientSideValidations()
      switch $('#wizard').steps('getStep', priorIndex).title
        when 'Sub Category'
          category = $('#service-request-form .category-wrapper input[type=radio]:checked').prev().find('p').html()
          subcategory = $('#service-request-form .subcategories-wrapper input[type=radio]:checked').parent().find('p').html() 
          $('.steps #wizard-t-0 .summary-data').html("#{category} / #{subcategory}")
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
          $('.summary-details-wrapper').find('.location').html($('#service-request-form .location_address').val())
          $('.steps #wizard-t-7 .summary-data').html($('#service-request-form .location_address').val())
        when 'Issue Image'
          setSummaryDetailsImages()
          $('.summary-details-wrapper').find('.location').html($('#service-request-form .location_address').val())
          if !$('.steps #wizard-t-6').parents('li:first').hasClass('disabled')
            images = $('.provide-photo-img').find('img').length
            $('.steps #wizard-t-6 .summary-data').html("#{images} Issue Image(s)")
      return
      
setSubcategoriesImages = (id) ->
  $('.subcategory_icons').addClass('hidden')
  $(".subcategory_icons.category-#{id}").removeClass('hidden')
  $(".subcategory_icons.category-#{id} img").each ->
    imgSrc = $(this).data('src')
    $(this).attr('src', imgSrc)
  $('#wizard').steps('next')
  
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
    if !($('form:visible').hasClass('logout-form'))
      $('.equipment-field-wrapper').removeClass('hidden')
    $('.select_equipment').select2()
    setEquipment()
  else
    $('a.problem-details-link').attr('data-equipment', true)
  brands.map((obj) -> (obj.text = obj.text or obj.name))
  $('.select_brand').empty()
  brands.unshift({id: 'prompt', text: 'Please select brand'})
  $('.select_brand').select2
    data: brands
  if brands.length == 0
    $('#service_request_brand_name').removeClass('hidden')
  if problem_codes.length > 0
    $('.steps #wizard-t-2').parents('li:first').removeClass('disabled')
    problem_codes.map((obj) -> (obj.text = obj.text or obj.name))
    $('.select_problem_code').empty()
    $('.select_problem_code').select2
      data: problem_codes
    $('#wizard').steps('next');
    $('#wizard #wizard-p-3 #back-btn, #wizard #wizard-p-4 #back-btn').removeData('step')
  else
    if $(this).data('equipment')
      $('#wizard').steps('setStep', 3)
      $('#wizard #wizard-p-1 #next-btn').data('step', 3)
      $('#wizard #wizard-p-3 #back-btn').data('step', 1)
    else
      $('#wizard').steps('setStep', 4)
      $('#wizard #wizard-p-1 #next-btn').data('step', 4)
      $('#wizard #wizard-p-4 #back-btn').data('step', 1)
    $('.steps #wizard-t-2').parents('li:first').addClass('disabled')
      
$(document).on 'select2:select', '.select_brand', (e)  ->
  $('#service_request_brand_name').val(e.params.data.text)
      
setEquipment = ->
  location_id = $('#service_request_location_id').val()
  subcategory_id = $('.subcategories-wrapper .subcategory_field').val()
  if location_id?
    $.ajax
      url: Routes.location_equipment_items_path(location_id: location_id, subcategory_id: subcategory_id)
      type: 'GET'
      dataType: 'json'
      success: (data) ->
        data.map((obj) -> (obj.text = obj.text or obj.subcategory.name))
        data.unshift({id: 'prompt', text: 'Please select equipment'})
        $('.select_equipment').empty()
        $('.select_equipment').select2 
          data: data
        
$(document).on 'select2:select', '.service-request-form-wrapper .select_equipment', (e) ->
  $('#service_request_brand_name').val(e.brand_name)
  $('#service_request_model').val(e.model)
  $('#service_request_serial').val(e.serial)
        
$(document).on 'click', '.service-request-form-wrapper .request-continue-btn', (e) ->
  e.preventDefault()
  $('#wizard').steps('next');
  
$(document).on 'click', '.service-request-form-wrapper .content-wrapper #back-btn', (e) ->
  e.preventDefault()
  if stepNumber = $(this).data('step')
    $('#wizard').steps('setStep', stepNumber);
  else
    $('#wizard').steps('previous');
    
$(document).on 'click', '.service-request-form-wrapper .content-wrapper #next-btn', (e) ->
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

$.onmount '.select_category', ->
  setCategories()

$(document).on 'select2:select, change', '.select_category', (e) ->
  setCategories()
  
$.onmount 'form#service-request-form', (e) ->
  if $(this).find('.has-error').length > 0
    $('section').css('display', 'none')
    $(this).find('.has-error').first().parents('section').css('display', 'block')
  
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
