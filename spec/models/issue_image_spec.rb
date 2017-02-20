require 'rails_helper'

describe IssueImage do
  it 'include Her::Model' do
    expect(IssueImage.include?(Her::Model)).to be_truthy
  end
  
  it 'include Her::FileUpload' do
    expect(IssueImage.include?(Her::FileUpload)).to be_truthy
  end

  it { expect(IssueImage.association_names.include? :service_request).to be_truthy }
  
  describe "attributes" do
    let(:issue_image) {IssueImage.new}
    it "include the :service_request_id attribute" do
      expect(issue_image).to have_attributes(:service_request_id => anything)
    end
    it "include the :image attribute" do
      expect(issue_image).to have_attributes(:image => anything)
    end
    it "include the :_destroy attribute" do
      expect(issue_image).to have_attributes(:_destroy => anything)
    end
  end
end

