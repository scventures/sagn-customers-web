require 'rails_helper'

describe EquipmentItem do
  it 'include Her::Model' do
    expect(EquipmentItem.include?(Her::Model)).to be_truthy
  end
  
  it 'have resource path customers/accounts/:account_id/locations/:location_id/equipment_items/:id' do
    expect(EquipmentItem.resource_path).to eq('customers/accounts/:account_id/locations/:location_id/equipment_items/:id')
  end
  
  it { expect(EquipmentItem.belongs_to(:location)).to be_truthy }
  it { expect(EquipmentItem.belongs_to(:category)).to be_truthy }
  it { expect(EquipmentItem.belongs_to(:sub_category)).to be_truthy }
  
  describe 'attributes' do
    let(:equipment_item) {EquipmentItem.new}
    it 'include attributes' do
      expect(equipment_item).to have_attributes(
        id: anything,
        model: anything,
        serial: anything,
        brand_name: anything,
        location_id: anything
      )
    end
  end
  
  describe ':as_json(options = nil)' do
    let(:equipment) { EquipmentItem.new(id: 1, name: 'Test') }
    it 'return json' do
      expect(equipment.as_json).to eq(equipment.attributes.as_json)
    end
  end
  
end
