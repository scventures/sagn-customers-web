require 'rails_helper'

describe EquipmentItem do
  it 'include Her::Model' do
    expect(EquipmentItem.include?(Her::Model)).to be_truthy
  end
  
  it 'have resource path customers/accounts/:account_id/locations/:location_id/equipment_items/:id' do
    expect(EquipmentItem.resource_path).to eq('customers/accounts/:account_id/locations/:location_id/equipment_items/:id')
  end
  
  it { expect(EquipmentItem.association_names.include? :location).to be_truthy }
  it { expect(EquipmentItem.association_names.include? :category).to be_truthy }
  it { expect(EquipmentItem.association_names.include? :sub_category).to be_truthy }
  
  describe 'attributes' do
    let(:equipment_item) {EquipmentItem.new}
    it 'include the :id attribute' do
      expect(equipment_item).to have_attributes(:id => anything)
    end
    it 'include the :model attribute' do
      expect(equipment_item).to have_attributes(:model => anything)
    end
    it 'include the :serial attribute' do
      expect(equipment_item).to have_attributes(:serial => anything)
    end
    it 'include the :brand_name attribute' do
      expect(equipment_item).to have_attributes(:brand_name => anything)
    end
    it 'include the :location_id attribute' do
      expect(equipment_item).to have_attributes(:location_id => anything)
    end
  end
  
  describe ':as_json(options = nil)' do
  
  end
  
end
