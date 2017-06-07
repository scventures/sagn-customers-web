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
  
  describe 'attributes' do
    let(:venue) {Venue.new}
    it 'include attributes' do
      expect(venue).to have_attributes( id: anything )
    end
  end
  
  describe '#images' do
    let(:venue) { Venue.new() }
    context 'for valid venue id' do
      it 'return images' do
        venue.id = 'validVenueId'
        stub_venue_images(venue.id, 200, venue_images_success_response)
        images = venue.images
        expect(images[:count]).to eq(1)
      end
    end
    context 'for invalid venue id' do
      it 'return error' do
        venue.id = 'invalidVenueId'
        stub_venue_images(venue.id, 400, venue_images_error_response)
        expect(venue.images).to be_nil
      end
    end
  end
end
