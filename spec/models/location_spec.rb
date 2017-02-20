require 'rails_helper'

describe Location do
  it 'include Her::Model' do
    expect(Location.include?(Her::Model)).to be_truthy
  end
  
  it 'parse_root_in_json true' do
    expect(Location.parse_root_in_json?).to be_truthy
  end
  
  it { expect(Location.association_names.include? :equipment_items).to be_truthy }
  
  describe "attributes" do
    let(:location) {Location.new}
    it "include the :id attribute" do
      expect(location).to have_attributes(:id => anything)
    end
    it "include the :name attribute" do
      expect(location).to have_attributes(:name => anything)
    end
  end
end
