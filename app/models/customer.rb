class Customer
  include Her::Model
  extend Devise::Models
  prepend DeviseOverrides
  include_root_in_json true

  attributes :email, :jwt, :password, :password_confirmation, :active,
             :current_account_id, :customer_account_ids, :name,
             :customer_account_name, :unconfirmed_phone, :tos_accepted,
             :confirmation_token

  devise :remote_authenticatable, :recoverable, :registerable, :confirmable
  
  has_many :accounts
  belongs_to :current_account, class_name: 'Account'

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

end
