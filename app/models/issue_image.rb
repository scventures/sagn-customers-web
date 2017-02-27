class IssueImage
  include Her::Model
  include Her::FileUpload
  
  has_file_upload :image
  attributes :service_request_id, :image, :_destroy
  belongs_to :service_request
end
