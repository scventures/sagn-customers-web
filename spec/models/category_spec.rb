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
    it 'include the :id attribute' do
      expect(category).to have_attributes(:id => anything)
    end
    it 'include the :name attribute' do
      expect(category).to have_attributes(:name => anything)
    end
    it 'include the :parent_category_id attribute' do
      expect(category).to have_attributes(:parent_category_id => anything)
    end
    it 'include the :problem_codes attribute' do
      expect(category).to have_attributes(:problem_codes => anything)
    end
    it 'include the :brands attribute' do
      expect(category).to have_attributes(:brands => anything)
    end
    it 'include the :is_equipment attribute' do
      expect(category).to have_attributes(:is_equipment => anything)
    end
    it 'include the :sub_brands attribute' do
      expect(category).to have_attributes(:sub_brands => anything)
    end
    it 'include the :manual_processing attribute' do
      expect(category).to have_attributes(:manual_processing => anything)
    end
  end
  
end

