setEquipment = ->
  equipments = $('.select_location option:selected').data('equipments')
  $('.select_equipment').find('option').remove()
  $.each equipments, (i, e) ->
    data_equipment = JSON.stringify e
    $('.select_equipment').append $('<option></option>').attr({'value': e.id, 'data-equipment': data_equipment }).text(e.id)

$('.select_location').livequery ->
  setEquipment()

$(document).on 'change', '.select_location', ->
  setEquipment()
  
setEquipmentFields = ->
  equipment = $('.select_equipment option:selected').data('equipment')
  $('#service_request_model').val(equipment.model)
  $('#service_request_serial').val(equipment.serial)
  $('#service_request_brand_name').val(equipment.brand_name)
  
$(document).on 'change', '.select_equipment', ->
  setEquipmentFields()
  
$(document).on 'change', '.select_equipment', ->
  setEquipmentFields()
  
window.add_field_for_images = (button, association, content) ->
  new_id = (new Date).getTime()
  regexp = new RegExp('new_' + association, 'g')
  $(button).button 'loading'
  setTimeout (->
    $(button).button 'reset'
  ), 3000
  $(content.replace(regexp, new_id)).hide().insertBefore($(button)).fadeIn 250
  $(button).button 'reset'
  
$('.image_upload').livequery ->
  $(this).on 'change', (event) ->
    files = event.target.files
    image = files[0]
    reader = new FileReader
    if image.type.match(/image\/(jpg|jpeg|pjpeg|png|x-png|gif)/i)
      reader.onload = (file) ->
        img = new Image
        $(event.target).parents('.image_wrapper').find('.image_upload_label').html $('<img>').attr(
          src: file.target.result
          class: 'img-preview')
      reader.readAsDataURL image
    else
      alert 'Supported File Formats Are: jpg, jpeg, png, gif'
