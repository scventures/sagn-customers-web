$.onmount '.address_auto_complete_field:visible, .edit_address_auto_complete_field:visible', ->
  window.placeAutocomplete = new google.maps.places.Autocomplete($(this)[0], types: [ 'geocode' ])
  placeAutocomplete.addListener('place_changed', fillInAddress);

componentForm =
  location_administrative_area_level_2: 'short_name'
  location_locality: 'long_name'
  location_administrative_area_level_1: 'short_name'
  location_country: 'long_name'
  location_sublocality_level_1: 'long_name'
  location_postal_code: 'short_name'

fillInAddress = ->
  place = placeAutocomplete.getPlace()
  $.each componentForm, (index, value) ->
    $("##{index}").val('') 
    $("##{index}").prop('disabled', false)
  if place.address_components.length > 1
    $.each place.address_components, (component, field) ->
      addressType = field.types[0]
      AddressType = "location_#{addressType}"
      if componentForm[AddressType]
        val = field.long_name
        if $("##{AddressType}").length > 0
          $("##{AddressType}").val(val)
  if place.geometry.location
    $('#location_geography_latitude').val(place.geometry.location.lat())
    $('#location_geography_longitude').val(place.geometry.location.lng())
  
$.onmount '.location-form-container .venue_name:visible, .restaurant-details .venue_name:visible', ->
  select = $(this).select2
    closeOnSelect: false
    minimumInputLength: 2
    delay: 250
    ajax:
      url: Routes.venues_path()
      dataType: 'JSON'
      type: 'GET'
      data: (params) ->
        data = {query: params['term']}
        if currentPosition
          data.ll = "#{currentPosition.coords.latitude}, #{currentPosition.coords.longitude}"
        else
          data.near = 'New York, NY'
        return data
      results: (data, page)->
        return data.result
      processResults: (data, params) ->
        venues = data.venues
        $.each venues, (i, loc) ->
          loc.text = loc.name
        results: data.venues
    templateResult: (data) =>
      if data.id
        fullAddress = [data.location.address, data.location.city, data.location.state].compact().join(', ')
        $('<div>').attr({'class': 'combo-list'}).html($('<h5>').html(data.name)).append($('<p>').html(fullAddress));
      else
        data.text
    dropdownParent: $('.select2-dropdown-container:visible')
  if $('#editLocation').is(':visible')
    $(select).select2 'open'
    $('#editLocation').find('.select2-search__field').val($('#edit_location_name').val()).trigger('change')
    $('#editLocation').find('.select2-search__field').trigger('keyup')
  select.on 'select2:open', (e,d) ->
    $('#wizard .content, #locations_index .main-wrapper').perfectScrollbar('destroy').css('overflow-y', 'hidden')
    select2Results = $('.select2-dropdown-container .select2-results__options')
    select2Results.css
      maxHeight: $('#wizard > .steps, .location-form-container .footer').offset().top - select2Results.offset().top - 21
  select.on 'select2:close', () ->
    $('#wizard .content, #locations_index .main-wrapper').css('overflow-y', 'auto').perfectScrollbar()

$(document).ready ->
  getLocation()

getLocation = ->
  if navigator.geolocation
    navigator.geolocation.getCurrentPosition LoadedCurrentPosition, ErrorGettingCurrentPosition

@currentPosition = null

LoadedCurrentPosition = (position)->
  @currentPosition = position

ErrorGettingCurrentPosition = (err) ->
  @currentPosition = null

$(document).on 'click', '.provide-address-btn', (e) ->
  e.preventDefault()
  $('.venue-address').addClass('hidden')
  $('.provide-address').removeClass('hidden')
  $('.venue-address .venue_name.select_venue').attr('disabled','disabled');
  $.onmount()
  
$(document).on 'select2:select', '.location-form-container .venue_name, .service-request-logout-form .venue_name', (e)->
  $('.location_name').val(e.params.data.name)
  $('.address_auto_complete_field').val(e.params.data.location.address)
  $('#location_geography_latitude').val(e.params.data.location.lat)
  $('#location_geography_longitude').val(e.params.data.location.lng)
  $('#location_locality').val(e.params.data.location.city)
  $('#location_administrative_area_level_1').val(e.params.data.location.state)
  $('#location_foursquare_venue_id').val(e.params.data.id)
  $('#location_postal_code').val(e.params.data.location.postalCode)
  $(this).parents('form').resetClientSideValidations()
  if $(this).parents('form').hasClass('service-request-logout-form')
    $('#wizard').steps('next')
  else
    if $('.location_name').val()
      $(this).parents('form').submit()
      
window.resetLocationForm = (form) ->
  $('.venue-address').removeClass('hidden')
  $('.provide-address').addClass('hidden')
  $(form)[0].reset()
  $(form).resetClientSideValidations()

$(document).on 'shown.bs.modal', '#addLocation', ->
  $('#addLocation .modal-body').find('.alert').remove()
  form = $(this).parents().find('form')
  resetLocationForm(form)
  $(form).enableClientSideValidations()

$(document).on 'click', '.location-images-container a.location-link', (e) ->
  $(this).find('.location-street-image').removeClass('no-pointer-events')

$(document).on 'mouseleave', '.location-images-container a.location-link', (e) ->
  $(this).find('.location-street-image').addClass('no-pointer-events')

window.locationStreetView = (lat, lng, location_id) ->
  $("#location-street-view-#{location_id}").removeClass('hidden')
  streetViewService = new (google.maps.StreetViewService)
  STREETVIEW_MAX_DISTANCE = 100
  latLng = new google.maps.LatLng lat, lng
  streetViewService.getPanoramaByLocation latLng, STREETVIEW_MAX_DISTANCE, (streetViewPanoramaData, status) ->
    if status == google.maps.StreetViewStatus.OK
      panorama = new google.maps.StreetViewPanorama document.getElementById("location-street-view-#{location_id}"),
        position:
          lat: lat
          lng: lng
        zoom: 1
    else
      $("#location-street-view-#{location_id}").html($('<span>').addClass('message').html('Location Image is not available.'))
      
$.onmount '#addLocation form, #editLocation form', ->
  if $(this).find('.form-group').hasClass('has-error')
    $(this).find('.location-fields').addClass('hidden')
    $(this).find('.has-error').parents('.location-fields').removeClass('hidden')
