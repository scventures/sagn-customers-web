class Customer
  include Her::Model
  include Her::FileUpload
  extend Devise::Models
  prepend DeviseOverrides
  include_root_in_json true

  resource_path 'customers/viewer'

  attributes :email, :jwt, :password, :password_confirmation, :active,
             :current_account_id, :customer_account_ids, :name,
             :customer_account_name, :unconfirmed_phone, :tos_accepted,
             :confirmation_token, :photo, :unconfirmed_email, :sms_confirmation_pin

  devise :remote_authenticatable, :recoverable, :registerable, :confirmable
  skip_callback :update, :before, :postpone_email_change_until_confirmation_and_regenerate_confirmation_token

  has_many :accounts
  belongs_to :current_account, class_name: 'Account'

  has_file_upload :avatar

  validates :avatar, file_size: { less_than_or_equal_to: 50.megabytes, message: 'File size exceeded. Maximum size 50MB.' },
                    file_content_type: { allow: ['image/gif', 'image/png', 'image/x-png', 'image/jpeg', 'image/pjpeg', 'image/jpg'], message: 'Image type not allowed. Allowed types are png/jpg/gif.' } 

  validates_presence_of     :password, if: :password_required?
  validates_confirmation_of :password, if: :password_required?

  def valid_auth_token?
    if jwt.present?
      begin
        token = JWT.decode jwt, nil, false
      rescue JWT::ExpiredSignature
        false
      end
    end
  end

  def populate_attributes
    c = Customer.get(:viewer)
    self.attributes = c.customer
  end

  def confirmable_email
    pending_reconfirmation? ? unconfirmed_email : email
  end

  def confirmation_pending?
    !confirmed? or pending_reconfirmation?
  end

  def phone_confirmation_pending?
    unconfirmed_phone and unconfirmed_phone != phone_number
  end

  def resend_phone_confirmation_instructions
    errors.add(:unconfirmed_phone, :blank) and return unless unconfirmed_phone?
    Customer.put_raw('customers/viewer/confirm_phone', customer: {unconfirmed_phone: unconfirmed_phone}) do |parsed_data, response|
      populate_errors(parsed_data[:errors]) if response.status == 400
    end
  end

  def verify_phone
    errors.add(:sms_confirmation_pin, :blank) and return unless sms_confirmation_pin?
    Customer.post_raw('customers/viewer/confirm_phone', sms_confirmation_pin: sms_confirmation_pin) do |parsed_data, response|
      errors.add(:sms_confirmation_pin, :invalid) unless response.success?
    end
    errors.blank?
  end

end
