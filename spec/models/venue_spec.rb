require 'rails_helper'

describe Venue do
  it 'include Her::Model' do
    expect(Venue.include?(Her::Model)).to be_truthy
  end
  
  it 'parse_root_in_json true' do
    expect(Venue.parse_root_in_json?).to eq(:venues)
  end
  
  it 'have collection path customers/venues' do
    expect(Venue.collection_path).to eq('customers/venues')
  end
end
