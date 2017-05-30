class EquipmentItemSerializer < ActiveModel::Serializer
  attributes :id, :text, :model, :serial, :brand_name, :location_id, :category, :subcategory, :brand
  
  def text
    brand_name = if object.brand?
        "(#{object.brand['name']})"
      elsif !object.brand_name.blank?
       "(#{object.brand_name })"
      end
    "#{object.subcategory['name']} #{brand_name}"
  end

end
