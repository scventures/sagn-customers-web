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
            content = "<div><h3>#{location.name}</h3><a href=#{Routes.new_service_request_path(location_id: location.id)} class='btn btn-red btn-lg'>SendaGuy to this location</a></div>"
            infowindow.setContent content
            infowindow.open map, marker
            return
        bounds.extend markerLatLng
      map.fitBounds bounds
  
window.initMap = ->
  if document.getElementById('google-map')
    map = new google.maps.Map document.getElementById('google-map'),
      minZoom: 1
      maxZoom: 21
      zoom: 4
      center: new google.maps.LatLng 37.09024, -95.712891
      mapTypeId: google.maps.MapTypeId.ROADMAP
    setMarkers(map)

$(document).ready ->
  google.maps.event.addDomListener(window, 'load', initMap);
  google.maps.event.addDomListener(window, 'turbolinks:load', initMap);

$(document).on 'click', '.map-container a.location-link', (e) ->
  e.preventDefault()
  id = $(this).data('id')
  google.maps.event.trigger markers[id], 'click'
  $('.map-container').find('button.location-btn').trigger('click')
  
$(document).on 'change', '.category-wrapper input[type=radio]', ->
  id = $(this).val()
  $('.content-wrapper').addClass('hidden')
  $('.content-wrapper.subcategories-wrapper').removeClass('hidden')
  $('.subcategory_icons').addClass('hidden')
  $(".subcategory_icons.category-#{id}").removeClass('hidden')
  $(".subcategory_icons.category-#{id} img").each ->
    imgSrc = $(this).data('src')
    $(this).attr('src', imgSrc)
  $('.category-wrapper').addClass('hidden')
  $('.service-request-form-wrapper .back-btn').removeClass('hidden')
    
$(document).on 'change', '.subcategories-wrapper input[type=radio]', ->
  $('.content-wrapper').addClass('hidden')
  $('.content-wrapper.describe-issue').removeClass('hidden')
  brands = $(this).data('brands')
  brands.map((obj) -> (obj.text = obj.text or obj.name))
  $('.select_brand').empty()
  $('.select_brand').select2
    data: brands
    
$(document).on 'click', '.service-request-form-wrapper .content-wrapper #back-btn', (e) ->
  e.preventDefault()
  $('.content-wrapper').addClass('hidden')
  back = $(this).data('back')
  $(".content-wrapper.#{back}").removeClass('hidden')

