setEquipment = ->
  equipments = $('.select_location option:selected').data('equipments')
  $('.select_equipment').find('option').remove()
  $('.select_equipment').append $('<option></option>')
  $.each equipments, (i, e) ->
    dataEquipment = JSON.stringify e
    $('.select_equipment').append $('<option></option>').attr({'value': e.id, 'data-equipment': dataEquipment }).text(e.id)

$('.select_location').livequery ->
  setEquipment()

$(document).on 'change', '.select_location', ->
  setEquipment()
  
setEquipmentFields = ->
  equipment = $('.select_equipment option:selected').data('equipment')
  console.log equipment.category
  $('#service_request_model').val(equipment.model)
  $('#service_request_serial').val(equipment.serial)
  $('#service_request_brand_name').val(equipment.brand_name)
  $('.new-equipment').addClass('hidden')
  $('.existing-equipment').removeClass('hidden')
  $('.select_brand').addClass('hidden')
  $('.input_brand').removeClass('hidden')
  
$(document).on 'change', '.select_equipment', ->
  setEquipmentFields()
  
$(document).on 'change', '.select_equipment', ->
  setEquipmentFields()
  
setCategories = ->
  categories = $('.select_category option:selected').data('categories')
  $('.select_subcategory').find('option').remove()
  $.each categories, (i, c) ->
    c = c.attributes
    dataSubcategory = JSON.stringify c
    $('.select_subcategory').append $('<option></option>').attr({'value': c.id, 'data-subcategory': dataSubcategory }).text(c.name)
    
$('.select_category').livequery ->
  setCategories()
    
$(document).on 'change', '.select_category', ->
  setCategories()
  
setSubcategories = ->
  subcategory = $('.select_subcategory option:selected').data('subcategory')
  $('.select_brand').find('option').remove()
  if subcategory.is_equipment == true
    $('.existing-equipment').removeClass('hidden')
    if subcategory.brands == "[]"
      $('.select_brand').removeClass('hidden').prop('disabled', false)
      $('.input_brand').addClass('hidden').prop('disabled', true)
    $.each subcategory.brands, (i, s) ->
      $('.select_subcategory').append $('<option></option>').attr('value', s.id).text(s.name)
  else
    $('.existing-equipment').addClass('hidden')
    $('.select_brand').addClass('hidden').prop('disabled', true)
    $('.input_brand').removeClass('hidden').prop('disabled', false)
    
$('.select_subcategory').livequery ->
  setSubcategories()
    
$(document).on 'change', '.select_subcategory', ->
  setSubcategories()
  
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
  $('.new-equipment').removeClass('hidden')
  $('.existing-equipment').addClass('hidden')
  
$(document).on 'change', '.radio-btn input[type="radio"]', ->
  if $(this).val() == 'send_a_guy'
    $('.select-guy').removeClass 'hidden'
    $('.select-guy select').prop 'disabled', false
  else
    $('.select-guy').addClass 'hidden'
    $('.select-guy select').prop 'disabled', true
