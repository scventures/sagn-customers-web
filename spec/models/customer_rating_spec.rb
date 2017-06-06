require 'rails_helper'
describe CustomerRating, type: :model do
  it 'include Her::Model' do
    expect(CustomerRating.include?(Her::Model)).to be_truthy
  end
  
  it 'have collection path customers/accounts/:account_id/service_requests/:service_request_id/assignments/:assignment_id/ratings' do
    expect(CustomerRating.collection_path).to eq('customers/accounts/:account_id/service_requests/:service_request_id/assignments/:assignment_id/ratings')
  end

  describe 'attributes' do
    let(:customer_rating) {CustomerRating.new}
    it 'include attributes' do
      expect(customer_rating).to have_attributes(
        stars: anything,
        comment: anything,
        assignment_id: anything,
        service_request_id: anything,
        account_id: anything
      )
    end
  end
  
  it { expect(CustomerRating.belongs_to(:assignment))}
  
  describe '#stars=(value)' do
    let(:customer_rating) {CustomerRating.new(stars: '0') }
    it 'return value in integer' do
      expect(customer_rating.stars).to eq(0)
    end
  end
  
end
