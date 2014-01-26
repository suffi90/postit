class User < ActiveRecord::Base
  include Sluggable

  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create

  sluggable_column :username

  def two_factor_auth?
    !self.phone.blank?
  end

  def generate_pin!
    self.update_column(:pin, rand(10 ** 6))
  end

  def remove_pin!
    self.update_column(:pin, nil)
  end

  def send_pin_to_twilio
    account_sid = '[Account Sid]'
    auth_token = '[Auth Token]'
    client = Twilio::REST::Client.new account_sid, auth_token
    msg = 'Hi, please input the pin to continue login: #{self.pin}'
    # two-factor authentication is disabled
      # client.account.messages.create({ :from => '+14150000000', :to => self.phone, :body => msg })
  end

  def admin?
    self.role == 'admin'
  end
end