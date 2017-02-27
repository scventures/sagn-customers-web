$(document).on 'ready', ->
  $('.select2').select2()

setEquipment = ->
  if $('.select_location option:selected').val() != ''
    equipments = $('.select_location option:selected').data('equipments')
    $('.existing-equipment').addClass('hidden')
    equipments.map((obj) -> (obj.text = obj.text or obj.id))
    $('.select_equipment').empty()
    $('.select_equipment').select2 
      data: equipments

$('.select_location').livequery ->
  setEquipment()

$(document).on 'select2:select', '.select_location', ->
  setEquipment()
    
setEquipmentFields = (id, location_id) ->
  $('.new-equipment').addClass('hidden')
  $('.equipment-warranty').addClass('hidden')
  $.ajax
    url: '/equipment_item'
    type: 'GET'
    dataType: 'json'
    data:
      location_id: location_id
      id: id
    success: (data) ->
      $('#service_request_category_id').val(data.category.id).trigger('select2:select')
      $('#service_request_subcategory_id').val(data.subcategory.id).trigger('select2:select')
      if data.category.attributes.is_equipment == true
        $('.existing-equipment').removeClass('hidden')
        $('#service_request_model').val(data.model)
        $('#service_request_serial').val(data.serial)
        brands = data.subcategory.brands
        brands.map((obj) -> (obj.text = obj.text or obj.name))
        $('.select_brand').empty()
        $('.select_brand').select2
          data: brands
        $('.equipment-warranty').removeClass('hidden')
        $('.equipment-warranty').find('a').addClass('hidden')
        
$('.select_equipment').livequery (e) ->
  if $(this).val() != ''
    setEquipmentFields(e.params.data.id, e.params.data.location_id)
  
$(document).on 'select2:select', '.select_equipment', (e)->
  setEquipmentFields(e.params.data.id, e.params.data.location_id)
  
$(document).on 'change', '.select_brand', (e) ->
  $('#service_request_brand_name').val(e.params.data.name)
  $('.equipment-warranty').find('a').removeClass('hidden')
  $('#brandInfoModal .modal-body').html('<p>'+brand.warranty_phone_number+'</p><p><a href='+e.params.data.warranty_lookup_url+'>'+e.params.data.warranty_lookup_url+'</p>')
  
setCategories = ->
  if $('.select_category option:selected').val() != ''
    categories = $('.select_category option:selected').data('categories')
    categories.map((obj) -> (obj.text = obj.text or obj.name))
    $('.select_subcategory').empty()
    $('.select_subcategory').select2
      data: categories
     
$('.select_category').livequery ->
  setCategories()
    
$(document).on 'select2:select', '.select_category', (e) ->
  setCategories()
  
setSubcategories = (subcategory) ->
  if subcategory
    $('.existing-equipment').addClass('hidden')
    if subcategory.is_equipment == true
      $('.equipment-warranty').removeClass('hidden')
      $('.equipment-warranty').find('a').addClass('hidden')
      $('.existing-equipment').removeClass('hidden')
      subcategory.brands.map((obj) -> (obj.text = obj.text or obj.name))
      $('.select_brand').empty()
      $('.select_brand').select2
        data: subcategory.brands
    else
      $('.existing-equipment').addClass('hidden')
 
$('.select_subcategory').livequery (e) ->
  if $(this).val() != ''
    setSubcategories(e.params.data)
        
$(document).on 'select2:select', '.select_subcategory', (e) ->
  if e.params!= 'undefined'
    setSubcategories(e.params.data)
  
$('.image-upload').livequery ->
  $(this).on 'change', (event) ->
    files = event.target.files
    image = files[0]
    reader = new FileReader
    if image.type.match(/image\/(jpg|jpeg|pjpeg|png|x-png|gif)/i)
      reader.onload = (file) ->
        img = new Image
        $(event.target).parents('.image-wrapper').find('.image-upload-label').html $('<img>').attr(
          src: file.target.result
          class: 'img-preview')
      reader.readAsDataURL image
    else
      alert 'Supported File Formats Are: jpg, jpeg, png, gif'
      
$(document).on 'click', '.new-equipment-btn', (e) ->
  e.preventDefault()
  $('.select_equipment').val('')
  $('.new-equipment').removeClass('hidden')
  $('.existing-equipment').addClass('hidden')
  
$(document).on 'change', '.radio-btn input[type="radio"]', ->
  if $(this).val() == 'send_a_guy'
    $('.select-guy').removeClass 'hidden'
    $('.select-guy select').prop 'disabled', false
  else
    $('.select-guy').addClass 'hidden'
    $('.select-guy select').prop 'disabled', true
