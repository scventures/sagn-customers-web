require 'rails_helper'

describe Category do
  it 'include Her::Model' do
    expect(Category.include?(Her::Model)).to be_truthy
  end
  
  it 'parse_root_in_json true' do
    expect(Category.parse_root_in_json?).to be_truthy
  end
  
  it 'have collection path customers/categories' do
    expect(Category.collection_path).to eq('customers/categories')
  end
  
  describe 'attributes' do
    let(:category) {Category.new}
    it 'include attributes' do
      expect(category).to have_attributes(
        id: anything,
        name: anything,
        parent_category_id: anything,
        problem_codes: anything,
        brands: anything,
        is_equipment: anything,
        sub_brands: anything,
        manual_processing: anything
      )
    end
  end
  
  describe '.as_json(options = nil)' do
    let(:category) { Category.new(id: 1, name: 'Test') }
    it 'return json' do
      expect(category.as_json).to eq(category.attributes.as_json)
    end
  end
  
end

