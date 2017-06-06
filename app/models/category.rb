class Category
  include Her::Model
  parse_root_in_json true, format: :active_model_serializers
  collection_path 'customers/categories'
  attributes :id, :name, :parent_category_id, :problem_codes, :brands, :is_equipment, :sub_brands, :manual_processing
  
  def as_json(options = nil)
    attributes.as_json
  end
  
end
