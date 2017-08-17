$(document).on 'cocoon:after-insert', '.issue-image-wrapper', (e, addedIssueImage) ->
  $(addedIssueImage).closest('form').enableClientSideValidations()

window.blockUI =
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
  if $('.service-request-form').hasClass('service-request-logout-form')
    subStepIndices = indices.concat([1, 2, 4, 5, 6, 9])
  else
    subStepIndices = indices.concat([1, 2, 4, 5, 8])
  steps = $('#wizard .steps ul li')
  subSteps = steps.filter(':eq(' + subStepIndices.join('), :eq(') + ')')
  parentSteps = steps.not subSteps
  parentSteps.removeAttr 'aria-substep'
  subSteps.attr 'aria-substep', true
  parentSteps.css
    width: "#{100 / parentSteps.length}%"

wizardStepChanged = (event, currentIndex, priorIndex) ->
  $('form:visible').enableClientSideValidations()
  li = $("#wizard-t-#{priorIndex}").parent()
  if li.hasClass('done') and !li.attr('aria-done')
    if currentIndex > priorIndex
      li.attr 'aria-done', true
    else
      li.removeClass('done')
    $("#wizard-p-#{priorIndex}").find('.next-btn').removeClass('hidden')
  if priorIndex == 3
    if $('#wizard-t-3').parents('li').hasClass('done')
      $('#wizard-t-3').parents('li').removeClass('in_progress').addClass('done').attr('aria-done', true)
    else
      $('#wizard-t-3').parents('li').removeClass('done').addClass('in_progress')
      li.removeAttr('aria-done')
  $("#wizard-p-#{currentIndex} .content-wrapper:not(.card-details)").find('input, select').enableClientSideValidations()
  switch $('#wizard').steps('getStep', priorIndex).title
    when 'Service Request'
      category = $('.service-request-form .category-wrapper input[type=radio]:checked').prev().find('p').html()
      subcategory_id = $('.subcategories-wrapper .subcategory_field').val() || $('.service-request-form .subcategories-wrapper input[type=radio]:checked').val()
      unless subcategory_id == ''
        subcategory = $(".service-request-form .subcategories-wrapper #service_request_subcategory_#{subcategory_id}, #subcategory_service_request_subcategory_#{subcategory_id}").parent().find('p').html()
      $('.steps #wizard-t-0 .summary-data').html([category, subcategory].filter(Boolean).join(' / '))
    when 'Sub Category'
      subcategory_id = $('.subcategories-wrapper .subcategory_field').val() || $('.service-request-form .subcategories-wrapper input[type=radio]:checked').val()
      category = $('.service-request-form .category-wrapper input[type=radio]:checked').prev().find('p').html()
      subcategory = $(".service-request-form .subcategories-wrapper #service_request_subcategory_#{subcategory_id}, #subcategory_service_request_subcategory_#{subcategory_id}").parent().find('p').html()
      $('.steps #wizard-t-0 .summary-data').html([category, subcategory].join(' / '))
      $('.summary-details-wrapper').find('.category').html("#{category} #{subcategory}")
    when 'Specific issue'
      $('.steps #wizard-t-2 .summary-data').html()
    when 'Order Details'
      if priorIndex == 3
        model = $('input.service_request_model').val()
        brand_name = $('#service_request_brand_name').val()
        serial = $('input.service_request_serial').val()
        data = $.grep([brand_name, model], Boolean).join(' ')
        data = $.grep([data, serial], Boolean).join(' - ')
        $('.steps #wizard-t-3 .summary-data').html(data)
        $('.summary-details-wrapper').find('.brand').html(data)
      else
        $summary_data = $('.steps #wizard-t-3 .summary-data')
        $summary_data.find('.urgent').remove()
        if $('.urgent-service').val() == 'Yes'
          content = 'Urgent Request'
          content = ', ' + content if $summary_data.html().length > 0
          $summary_data.append($('<span>').addClass('urgent').html(content))
          $('.steps #wizard-t-4:visible .summary-data').html('Urgent Request')
        else
          $summary_data.find('.urgent').remove()
          $('.steps #wizard-t-4:visible .summary-data').html('')
    when 'Restaurant Details'
      location = $('.service-request-form .location_name').val() || $('.service-request-form .location_address').val()
      $('.summary-details-wrapper').find('.location').html(location)
      $('.steps #wizard-t-7 .summary-data').html(location)
      $('.venue-address .venue_name.select_venue').removeAttr('disabled');
    when 'Issue Image'
      setSummaryDetailsImages()
      $('.summary-details-wrapper').find('.location').html($('.service-request-form .location_name').val())
      if !$('.steps #wizard-t-6').parents('li:first').hasClass('disabled')
        images = $('.provide-photo-img').find('img').length
        $('.steps #wizard-t-6 .summary-data').html("#{images} Issue Image(s)")
      $('.venue-address').removeClass('hidden')
      $('.provide-address').addClass('hidden')
  if $('#wizard').steps('getStep', currentIndex).title == 'Summary' and $('.warranty-warning-wrapper').hasClass('no-warning')
    $('.steps a#wizard-t-7').parent('li').addClass('done')
  $.onmount()
  updatePerfectScroll('#wizard > .content', true)
  return
  
wizardStepChanging = (event, currentIndex, newIndex, form) ->
  currentStep = $('#wizard').steps('getStep', currentIndex)
  title = currentStep.title
  if title == 'Summary &amp; Payment'
    $('.service-request-logout-form p.title').addClass('hidden')
  else
    $('.service-request-logout-form p.title').removeClass('hidden')
  valid = true
  if newIndex > currentIndex
    $(form).resetClientSideValidations()
    $.each $("#wizard-p-#{currentIndex} .content-wrapper:not(.card-details)").find("select:not(.select_problem_code), textarea, input.image-upload, input.location_name, input.address_auto_complete_field").filter(':visible'), (i, element) ->
      valid = $(element).isValid(form[0].ClientSideValidations.settings.validators) and valid
      return
    if !currentStep.skipping and valid and $('.subcategories-wrapper input[type=radio]:checked').data('equipment') == true
      if title == 'Order Details' and currentIndex == 3 and !$('.wizard').hasClass('skip-confirmation')
        if !currentStep.skipped and $('input.service_request_model, #service_request_brand_name, input.service_request_serial').filter((->
            @value == ''
          )).length
          dataConfirmModal.confirm
            title: 'Please Provide Details',
            text: "We'll be able to better service your request if you provide brand, model and serial number of your equipment.",
            commit: 'Skip',
            cancel: 'Ok',
            zIindex: 10099,
            onConfirm: ()=>
              currentStep.skipped = true
              $('#wizard').steps('setStep', newIndex)
              currentStep.skipped = false
          return false
  return valid
  
wizardInit = () ->
  $('#wizard > .steps').appendTo '#wizard'
  markSubSteps()
  $('#wizard').removeClass('loading')
  return
  
wizardDefaultOptions =
  headerTag: 'h2'
  bodyTag: 'section'
  transitionEffect: 'slideLeft'
  enableKeyNavigation: false
  autoFocus: false
  titleTemplate: '<div class="number step-#index#"><div class="line line-left"></div><div class="line line-right"></div><div class="icon"></div><div class="title">#title#</div><div class="summary-data grey"></div></div>'

$.onmount '.service-request-logout-form-wrapper #wizard', ->
  $(this).steps $.extend({
    onInit: ->
      wizardInit()
    onStepChanging: (event, currentIndex, newIndex) ->
      form = $("#wizard-p-#{currentIndex}").find('form:first')
      $(form).enableClientSideValidations()
      wizardStepChanging(event, currentIndex, newIndex, form)
    onStepChanged: (event, currentIndex, priorIndex) ->
      wizardStepChanged(event, currentIndex, priorIndex)
  }, wizardDefaultOptions)

$.onmount '.service-request-loggedin-form #wizard', ->
  $(this).steps $.extend({
    onInit: ->
      wizardInit()
    onStepChanging: (event, currentIndex, newIndex) ->
      form = $(this).parents('form:first')
      wizardStepChanging(event, currentIndex, newIndex, form)
    onStepChanged: (event, currentIndex, priorIndex) ->
      wizardStepChanged(event, currentIndex, priorIndex)
  }, wizardDefaultOptions)

window.setSubcategoriesImages = (id) ->
  $('.subcategory_icons').addClass('hidden')
  $(".subcategory_icons.category-#{id}").removeClass('hidden')
  $(".subcategory_icons.category-#{id} img").each ->
    imgSrc = $(this).data('src')
    $(this).attr('src', imgSrc)
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
            data: data
            placeholder: 'Select Equipment'
          $('.select_equipment').select2 'val', 'Select Equipment'

$(document).on 'click', '.category-wrapper input[type=radio]', ->
  setSubcategoriesImages($(this).val())
  
$(document).on 'change', '.category-wrapper input[type=radio]', ->
  $('.steps li:not(:first)').removeClass('done in_progress').addClass('disabled').removeAttr('aria-done').find('.summary-data').html('')
  $('.subcategories-wrapper .subcategory_field').val('')
  $("#wizard-t-1").find('.next-btn').addClass('hidden')
  $('.steps #wizard-t-3 .summary-data').html('')
  
$(document).on 'change', '.subcategories-wrapper input[type=radio]', ->
  $("#wizard-p-1").find('.next-btn').removeClass('hidden')
  $('.steps #wizard-t-3 .summary-data').html('')
  
$(document).on 'click', '.subcategories-wrapper input[type=radio]', ->
  $('.subcategories-wrapper .subcategory_field').val($(this).val())
  brands = $(this).data('brands')
  problem_codes = $(this).data('problem-codes')
  $('.equipment_wrapper').addClass('hidden')
  $('.equipment-field-wrapper').addClass('hidden')
  $('#service_request_brand_name').val('')
  brands.map((obj) -> (obj.text = obj.text or obj.name))
  category = $('.service-request-form .category-wrapper input[type=radio]:checked').prev().find('p').html()
  if $(this).data('equipment')
    $('.warranty-warning-wrapper').removeClass('no-warning')
    $('.equipment_wrapper').removeClass('hidden')
    if !($('form:visible').hasClass('service-request-logout-form'))
      $('form:visible').block blockUI
      setEquipment()
    if brands.length > 0
      $('#service_request_brand_name').addClass('hidden')
  else
    $('.warranty-warning-wrapper').addClass('no-warning')
    $('.equipment_wrapper').find('select, input').val('')
    $('a.problem-details-link').attr('data-equipment', true)
  $('.select_brand').empty()
  $('.select_brand').select2
    width: '100%'
    data: brands
    placeholder: 'Select Brand'
  $('.select_brand').select2 'val', 'Select Brand'
  if brands.length == 0
    $('#service_request_brand_name').removeClass('hidden')
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
      $('.warranty-warning-wrapper').removeClass('no-warning')
      $('#wizard').steps('setStep', 3)
      $('#wizard #wizard-p-1 .next-btn').data('step', 3)
      $('#wizard #wizard-p-3 .back-btn').data('step', 1)
      setBreadcrumb(null, 3)
    else
      $('.warranty-warning-wrapper').addClass('no-warning')
      $('#wizard').steps('setStep', 4)
      $('#wizard #wizard-p-1 .next-btn').data('step', 4)
      $('#wizard #wizard-p-4 .back-btn').data('step', 1)
      setBreadcrumb(3, 4)
      
$(document).on 'click', '.warranty-warning input[type=submit]', (e) ->
  e.preventDefault()
  $('.warranty-warning-wrapper').addClass('no-warning')
  if $('.warranty-warning-wrapper').hasClass('no-warning')
    $('.steps a#wizard-t-7').parent('li').addClass('done')

setBreadcrumb = (stepToHide, stepToShow) ->
  $.each [4, 5], (i, elem) ->
    $("#wizard-t-#{elem}").parents('li').attr('aria-substep', true)
  $("#wizard-t-#{stepToHide}").parents('li').addClass('hidden') if stepToHide
  $("#wizard-t-#{stepToShow}").parents('li').removeAttr('aria-substep').removeClass('hidden')
  $('.summary-details-wrapper .details-wrapper').find('a.order-details-link').data('step', stepToShow)
      
$(document).on 'select2:select', '.select_brand', (e)  ->
  $('#service_request_brand_name').val(e.params.data.text)
      
$(document).on 'select2:select', '.service-request-form-wrapper .select_equipment', (e) ->
  if e.params.data.brand
    $('#service_request_brand_id').val(e.params.data.brand.id).trigger('change')
    $('#service_request_brand_name').val(e.params.data.brand.name)
  $('#service_request_model').val(e.params.data.model)
  $('#service_request_serial').val(e.params.data.serial)
        
$(document).on 'click', '.service-request-form-wrapper .content-wrapper .back-btn', (e) ->
  e.preventDefault()
  if stepNumber = $(this).data('step')
    $('#wizard').steps('setStep', stepNumber);
  else
    $('#wizard').steps('previous');
    
$(document).on 'click', '.service-request-form-wrapper .request-continue-btn.address-details',  (e) ->
  e.preventDefault()
  $('.provide-address').find('input.location_name, input.address_auto_complete_field').enableClientSideValidations()
  $('.provide-address').find('input.location_name:first, input.address_auto_complete_field:first').focus()

$(document).on 'click', '.service-request-form-wrapper .content-wrapper .next-btn, .service-request-form-wrapper .request-continue-btn',  (e) ->
  e.preventDefault()
  if stepNumber = $(this).data('step')
    $('#wizard').steps('setStep', stepNumber);
  else
    $('#wizard').steps('next');

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
  
$(document).on 'click', '.left-sidebar ul li a.past-requests-link', (e) ->
  e.preventDefault()

$(document).on 'keyup', '.us_phone_number', ->
  phone_number = $(this).val()
  if isValidNumber(phone_number.replace(/ /g, ''), 'US')
    phone_number = formatNumberForMobileDialing('US', phone_number)
    $(this).val(phone_number)

$(document).on 'cocoon:after-insert', '.provide-photo', (e, addedImage) ->
  $(addedImage).find('.image-upload').enableClientSideValidations()
  $(addedImage).find('.image-upload').trigger('click')
  
$(document).on 'click', '.details-change-link', (e) ->
  e.preventDefault()
  $('#wizard').steps('setStep', $(this).data('step'));
  
setSummaryDetailsImages = ->
  $('.summary-details-wrapper').find('.issue_image').html('')
  if $('.provide-photo-img').find('img').length == 0
    $('.summary-details-wrapper').find('.issue_image').html('No photos added')
  else
    $('.summary-details-wrapper').find('.issue_image').html('')
    images = $('.provide-photo-img').find('img').map(->
      $(this).attr 'src'
    ).get()
    $.each images, (i, img) ->
      $('.summary-details-wrapper').find('.issue_image').append($('<img>').attr(src: img, class: 'preview img-responsive'))
      
$(document).on 'click', '.service-request-signin-link', (e) ->
  e.preventDefault()
  form = $(this).parents('form:first')
  $('.signup-header').addClass('hidden')
  $('.signin-header').removeClass('hidden')
  $('.sign-up-fields').addClass('hidden')
  $('.sign-up-fields :input').prop('disabled', true)
  $('.sign-in-fields :input').prop('disabled', false)
  $('.sign-in-fields').removeClass('hidden')

$(document).on 'click', '.service-request-signup-link', (e) ->
  e.preventDefault()
  form = $(this).parents('form:first')
  $('.signup-header').removeClass('hidden')
  $('.signin-header').addClass('hidden')
  $('.sign-up-fields').removeClass('hidden')
  $('.sign-in-fields').addClass('hidden')
  $('.sign-up-fields :input').prop('disabled', false)
  $('.sign-in-fields :input').prop('disabled', true)
  
$(document).on 'keypress', 'form.service-request-form', (e) ->
  if e.which != 13
    return
  e.preventDefault()

$.onmount '.location-container', ->
  $this = $(this)
  $(this).blockUI
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
  
$(document).on 'submit', '.block-on-submit', ->
  $('form').block blockUI

$(document).on 'ajax:complete', '.block-on-submit', ->
  $('form').unblock()
  
$(document).on 'submit', 'form.service-request-logout-form', ->
  service_request_forms = $('form.service-request-logout-form:not(.customer-form)')
  service_request_data = {}
  $.each service_request_forms, (i, form) ->
    $.extend( service_request_data, $(form).serializeObject())
  db = new PouchDB('sagn')
  db.get 'location', (err, doc) ->
    if err
      db.put {
        _id: 'location'
        title: service_request_data
      }, (err, response) ->
        return
    else
      db.put {
        _id: 'location'
        _rev: doc._rev
        title: service_request_data
      }, (err, response) ->
        return

window.dispatchFromLocalStorage = (verified) ->
  db = new PouchDB('sagn')
  db.get 'location', (err, doc) ->
    unless err
      unless verified
        $.ajax
          url: Routes.verify_customer_customers_path()
          type: 'GET'
          dataType: 'JSON'
          success: (data) ->
            if data.verified
              postServiceRequest()
      else
        postServiceRequest()

window.postServiceRequest = ->
  db = new PouchDB('sagn')
  db.get 'location', (err, doc) ->
    if doc
      location = doc.title
      $.ajax
        url: Routes.create_with_service_request_locations_path()
        type: 'POST'
        dataType: 'script'
        data: location
        beforeSend: (xhr) ->
          xhr.setRequestHeader 'X-Turboboost', 1
          return

window.removeServiceRequest= ->
  db = new PouchDB('sagn')
  db.get 'location', (err, doc) ->
    if doc
      db.remove doc, (err, doc) ->
