class IssueImage
  include Her::Model
  include Her::FileUpload
  include ActiveModel::Validations
  
  has_file_upload :image
  attributes :service_request_id, :image, :_destroy
  belongs_to :service_request
  
  validates :image, file_size: { less_than_or_equal_to: 50.megabytes, message: 'File size exceeded. Maximum size 50MB.' },
                     file_content_type: { allow: ['image/gif', 'image/png', 'image/x-png', 'image/jpeg', 'image/pjpeg', 'image/jpg'], message: 'Image type not allowed. Allowed types are png/jpg/gif.' } 
end
