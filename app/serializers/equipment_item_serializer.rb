class EquipmentItemSerializer < ActiveModel::Serializer
  attributes :id, :text, :model, :serial, :brand_name, :location_id, :category, :subcategory, :brand
  
  def text
    brand_name = "(#{object.brand_name || object.brand['name']})" if object.brand_name? or object.brand?
    "#{object.subcategory['name']} #{brand_name}"
  end

end
