require 'rails_helper'

describe IssueImage do
  it 'include Her::Model' do
    expect(IssueImage.include?(Her::Model)).to be_truthy
  end
  
  it 'include Her::FileUpload' do
    expect(IssueImage.include?(Her::FileUpload)).to be_truthy
  end

  it { expect(IssueImage.belongs_to(:service_request)).to be_truthy }
  
  describe "attributes" do
    let(:issue_image) {IssueImage.new}
    it "include attributes" do
      expect(issue_image).to have_attributes(
        service_request_id: anything,
        image: anything,
        image_base64: anything,
        _destroy: anything
      )
    end
  end
end

