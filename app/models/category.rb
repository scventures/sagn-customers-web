class Category
  include Her::Model
  attributes :id, :name, :parent_category_id, :problem_codes, :brands, :is_equipment, :sub_brands, :manual_processing
  has_many :sub_categories, class_name: 'Category', foreign_key: 'parent_category_id'  
  
  scope :sub_categories, -> { where(parent_category_id: null) }
end
