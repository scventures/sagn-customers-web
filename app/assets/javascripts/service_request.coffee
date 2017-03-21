$(document).on 'ready', ->
  $('.select2').select2()

setEquipment = ->
  location_id = $('.select_location option:selected').val()
  if location_id != ''
    $('.place-request-service-wrapper').block
      message: '<i class="fa fa-spinner fa-spin fa-4x"></i>'
      css:
        border: 'none'
        background: 'none'
        color: '#808080'
      overlayCSS:
        backgroundColor: 'transparent'
        cursor: 'wait'
    $.ajax
      url: '/location/'+location_id+'/equipment_items'
      type: 'GET'
      dataType: 'json'
      success: (data) ->
        $('.place-request-service-wrapper').unblock()
        data.map((obj) -> (obj.text = obj.text or obj.subcategory.name))
        $('.select_equipment').empty()
        data.unshift({id: 'prompt', text: 'Please select equipment'})
        $('.select_equipment').select2 
          data: data
   

$('.select_location').livequery ->
  setEquipment()

$(document).on 'select2:select, change', '.select_location', ->
  setEquipment()
    
setEquipmentFields = (equipment) ->
  $('.new-equipment').addClass('hidden')
  $('.equipment-warranty').addClass('hidden')
  $('#service_request_category_id').val(equipment.category.id).trigger('change')
  $('#service_request_subcategory_id').val(equipment.subcategory.id).trigger('change')
  $('.existing-equipment').removeClass('hidden')
  $('#service_request_model').val(equipment.model)
  $('#service_request_serial').val(equipment.serial)
  brands = equipment.subcategory.brands
  brands.map((obj) -> (obj.text = obj.text or obj.name))
  $('.select_brand').empty()
  brands.unshift({id: 'prompt', text: 'Please select brand'})
  brands.push({ id: 'other', text: 'Other'})
  $('.select_brand').select2
    data: brands
  $('.equipment-warranty').removeClass('hidden')
  $('.equipment-warranty').find('a').addClass('hidden')
      
$('.select_equipment').livequery (e) ->
  if $(this).val() != ''
    setEquipmentFields(e.params.data)
  
$(document).on 'select2:select', '.select_equipment', (e)->
  if $(this).val() != '' && $(this).val() != 'prompt'
    setEquipmentFields(e.params.data)
  
$(document).on 'select2:select', '.select_brand', (e) ->
  $('.service_request_brand_name').find('label, input').addClass('hidden')
  if $('.select_brand').val() == 'other'
    $('.service_request_brand_name').find('label, input').removeClass('hidden')
  $('#service_request_brand_name').val(e.params.data.name)
  $('.equipment-warranty').find('a').addClass('hidden')
  modal_body = ''
  if e.params.data.id != 'prompt' && e.params.data.id != 'other'
    if e.params.data.warranty_lookup_url != "" && e.params.data.warranty_lookup_url != 'undefined'
      modal_body += '<p>Warranty Url: <a href='+e.params.data.warranty_lookup_url+'>'+e.params.data.warranty_lookup_url+'</a></p>'
    if e.params.data.warranty_phone_number != "" && e.params.data.warranty_phone_number != 'undefined'
      modal_body += '<p>Warranty Phone Number: '+e.params.data.warranty_phone_number+'</p>'
    if modal_body != ""
      $('.equipment-warranty').find('a').removeClass('hidden')
      $('#brandInfoModal .modal-body').html(modal_body)
    
setCategories = ->
  if $('.select_category option:selected').val() != ''
    categories = $('.select_category option:selected').data('categories')
    categories.map((obj) -> (obj.text = obj.text or obj.name))
    $('.select_subcategory').empty()
    categories.unshift({id: 'prompt', text: 'Please select category'})
    $('.select_subcategory').select2
      data: categories
     
$('.select_category').livequery ->
  setCategories()
    
$(document).on 'select2:select, change', '.select_category', (e) ->
  setCategories()
  
setSubcategories = (subcategory) ->
  if subcategory
    $('.existing-equipment').addClass('hidden')
    $('.equipment-warranty').removeClass('hidden')
    $('.equipment-warranty').find('a').addClass('hidden')
    $('.existing-equipment').removeClass('hidden')
    subcategory.brands.map((obj) -> (obj.text = obj.text or obj.name))
    $('.select_brand').empty()
    subcategory.brands.unshift({id: 'prompt', text: 'Please select brand'})
    subcategory.brands.push({ id: 'other', text: 'Other'})
    $('.select_brand').select2
      data: subcategory.brands
        
$(document).on 'select2:select', '.select_subcategory', (e) ->
  if e.params != 'undefined' && e.params.data != 'undefined'
    setSubcategories(e.params.data)
  
$('.image-upload').livequery ->
  $(this).on 'change', (event) ->
    files = event.target.files
    image = files[0]
    reader = new FileReader
    reader.onload = (file) ->
      img = new Image
      $(event.target).parents('.image-wrapper').find('.image-upload-label').html $('<img>').attr(
        src: file.target.result
        class: 'img-preview')
      $(event.target).focusout()
    reader.readAsDataURL image
    
$(document).on 'cocoon:after-insert', '.issue-image-wrapper', (e, addedIssueImage) ->
  $(addedIssueImage).closest('form').enableClientSideValidations()
  
$(document).on 'click', '.new-equipment-btn', (e) ->
  e.preventDefault()
  $(".select_equipment").val('').trigger('change')
  $(".select_category").val('').trigger('change')
  $(".select_subcategory").empty()
  $(".select_brand").val('').empty()
  $('.new-equipment').toggleClass('hidden')
  $('.existing-equipment').addClass('hidden')
  
$(document).on 'change', '.radio-btn input[type="radio"]', ->
  if $(this).val() == 'send_a_guy'
    $('.select-guy').removeClass 'hidden'
    $('.select-guy select').prop 'disabled', false
  else
    $('.select-guy').addClass 'hidden'
    $('.select-guy select').prop 'disabled', true
