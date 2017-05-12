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
  
$.onmount '.location-form-container .venue_name', ->
  $(this).select2
    theme: 'paper'
    closeOnSelect: false
    minimumInputLength: 2
    ajax:
      url: Routes.venues_path()
      dataType: 'JSON'
      type: 'GET'
      data: (params) ->
        if $('.main-wrapper').data('ll')
          {ll: $('.main-wrapper').data('ll'), query: params['term'] }
        else
          {intent: 'global', query: params['term'] }
      results: (data, page)->
        return data.result
      processResults: (data, params) ->
        results: data
    templateResult: (data) =>
      if data.id
        $('<div>').attr({'class': 'combo-list'}).html($('<h5>').html(data.name)).append($('<p>').html(data.location.address));
      else
        data.text
    dropdownParent: $('.select2-dropdown-container')

$(document).ready ->
  getLocation()

getLocation = ->
  if navigator.geolocation
    navigator.geolocation.getCurrentPosition showPosition

showPosition = (position) ->
  ll = "#{position.coords.latitude},#{position.coords.longitude}"
  $('.main-wrapper').attr('data-ll', ll)

$(document).on 'click', '.provide-address-btn', (e) ->
  e.preventDefault()
  $('.venue-address').addClass('hidden')
  $('.provide-address').removeClass('hidden')
  
$(document).on 'select2:select', '.location-form-container .venue_name', (e)->
  $('.location_name').val(e.params.data.name)
  $('.address_auto_complete_field').val(e.params.data.location.address)
  $('#location_geography_latitude').val(e.params.data.location.lat)
  $('#location_geography_longitude').val(e.params.data.location.lng)
  $('#location_locality').val(e.params.data.location.city)
  $('#location_administrative_area_level_1').val(e.params.data.location.state)
  if $('.location_name').val()
    $(this).parents('form').submit()

$(document).on 'shown.bs.modal', '#addLocation', ->
  $('.venue-address').removeClass('hidden')
  $('.provide-address').addClass('hidden')
  $(this).parents().find('form')[0].reset()
  $('form').resetClientSideValidations()
