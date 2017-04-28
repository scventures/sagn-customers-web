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
      map.fitBounds bounds
  
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
  
$(document).on 'change, click', '.category-wrapper input[type=radio]', ->
  id = $(this).val()
  setContentWrapperClass('subcategories-wrapper')
  $('.subcategory_icons').addClass('hidden')
  $(".subcategory_icons.category-#{id}").removeClass('hidden')
  $(".subcategory_icons.category-#{id} img").each ->
    imgSrc = $(this).data('src')
    $(this).attr('src', imgSrc)
  $('.category-wrapper').addClass('hidden')
  $('.service-request-form-wrapper .back-btn').removeClass('hidden')
    
$(document).on 'change, click', '.subcategories-wrapper input[type=radio]', ->
  $('.subcategories-wrapper .subcategory_field').val($(this).val())
  brands = $(this).data('brands')
  problem_codes = $(this).data('problem-codes')
  $('.select_equipment').empty()
  if $('.select_equipment').length > 0
    setEquipment()
  brands.map((obj) -> (obj.text = obj.text or obj.name))
  $('.select_brand').empty()
  $('.select_brand').select2
    data: brands
  if brands.length == 0
    $('#service_request_brand_name').removeClass('hidden')
  if problem_codes.length > 0
    problem_codes.map((obj) -> (obj.text = obj.text or obj.name))
    $('.select_problem_code').empty()
    $('.select_problem_code').select2
      data: problem_codes
    setContentWrapperClass('issue-wrapper')
  else
    setContentWrapperClass('describe-issue')
    
      
setEquipment = ->
  location_id = $('#service_request_location_id').val()
  subcategory_id = $('.subcategories-wrapper .subcategory_field').val()
  if location_id != ''
    $.ajax
      url: Routes.location_equipment_items_path(location_id: location_id, subcategory_id: subcategory_id)
      type: 'GET'
      dataType: 'json'
      success: (data) ->
        data.map((obj) -> (obj.text = obj.text or obj.subcategory.name))
        data.unshift({id: 'prompt', text: 'Please select equipment'})
        $('.select_equipment').select2 
          data: data
        
$(document).on 'select2:select', '.service-request-form-wrapper .select_equipment', (e) ->
  $('#service_request_brand_name').val(e.brand_name)
  $('#service_request_model').val(e.model)
  $('#service_request_serial').val(e.serial)
        
$(document).on 'click', '.service-request-form-wrapper .request-continue-btn', (e) ->
  e.preventDefault()
  setContentWrapperClass($(this).data('continue'))
  
$(document).on 'click', '.service-request-form-wrapper .content-wrapper #back-btn', (e) ->
  e.preventDefault()
  back = $(this).data('back')
  setContentWrapperClass(back)

$(document).on 'click', '.service-request-form-wrapper .btn-schedule-service', (e) ->
  e.preventDefault()
  setContentWrapperClass('complete-request')
  if ($(this).data('payment'))
    $('.service-request-form-wrapper .card-wrapper').addClass('hidden')

$(document).on 'click', '.service-request-form-wrapper .request-service-card-btn', (e) ->
  e.preventDefault()
  if $(this).data('card') == 'add'
    $('.service-request-form-wrapper .card-wrapper').removeClass('hidden')
  else
    $('.service-request-form-wrapper .card-wrapper').addClass('hidden')
  
setContentWrapperClass = (selector) ->
  $('.content-wrapper').addClass('hidden')
  $(".content-wrapper.#{selector}").removeClass('hidden')
  $('.main-wrapper').scrollTop(0)
  return

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

$(document).on 'click', '.left-sidebar ul li a.past-requests-link', (e) ->
  e.preventDefault()
