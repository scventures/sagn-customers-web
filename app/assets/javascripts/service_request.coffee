setEquipment = ->
  equipments = $('.select_location option:selected').data('equipments')
  $('.select_equipment').find('option').remove()
  $('.select_equipment').append $('<option></option>')
  $('.existing-equipment').addClass('hidden')
  $.each equipments, (i, e) ->
    dataEquipment = JSON.stringify e
    $('.select_equipment').append $('<option></option>').attr({'value': e.id, 'data-equipment': dataEquipment }).text(e.id)

$('.select_location').livequery ->
  setEquipment()

$(document).on 'change', '.select_location', ->
  setEquipment()
  
setEquipmentFields = ->
  equipment = $('.select_equipment option:selected').data('equipment')
  $('.new-equipment').addClass('hidden')
  $('.equipment-warranty').addClass('hidden')
  if equipment
    $.ajax
      url: '/equipment_item'
      type: 'GET'
      dataType: 'json'
      data:
        location_id: $('.select_location').val()
        id: $('.select_equipment').val()
      success: (data) ->
        $('#service_request_category_id').append("<option selected='selected' value='+data.category.attributes.id+'>'+data.category.attributes.name+'</option>")
        $('#service_request_subcategory_id').append("<option selected='selected' value='+data.subcategory.id+'>'+data.subcategory.name+'</option>")
        $('.select_brand').find('option').remove()
        if data.category.attributes.is_equipment == true
          $('.existing-equipment').removeClass('hidden')
          $('#service_request_model').val(data.model)
          $('#service_request_serial').val(data.serial)
          $.each data.category.attributes.brands, (i, b) ->
            brand = JSON.stringify b        
            $('.select_brand').append $('<option></option>').attr({'value': b.id, 'data-brand': brand }).text(b.name)
          $('.equipment-warranty').removeClass('hidden')
          $('.equipment-warranty').find('a').addClass('hidden')
        
$(document).on 'change', '.select_brand', ->
  value = $('.select_brand').data('brand-name')
  $('#service_request_brand_name').val(value)
  brand = $('.select_brand:selected').data('brand')
  $('.equipment-warranty').find('a').removeClass('hidden')
  $('#brandInfoModal .modal-body').html('<p>'+brand.warranty_phone_numbe+'</p><p><a href='+brand.warranty_lookup_url+'>'+brand.warranty_lookup_url+'</p>')    
  
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
  if subcategory
    $('.select_brand').find('option').remove()
    $('.existing-equipment').addClass('hidden')
    if subcategory.is_equipment == true
      $('.equipment-warranty').removeClass('hidden')
      $('.equipment-warranty').find('a').addClass('hidden')
      $('.existing-equipment').removeClass('hidden')
      if subcategory.brands == "[]"
        $('.select_brand').removeClass('hidden').prop('disabled', false)
        $('.input_brand').addClass('hidden').prop('disabled', true)
      $.each subcategory.brands, (i, s) ->
        $('.select_subcategory').append $('<option></option>').attr('value', s.id).text(s.name)
    else
      $('.existing-equipment').addClass('hidden')
    
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
