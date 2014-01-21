class User < ActiveRecord::Base
  include Voteable

  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create

  after_validation :generate_slug

  def generate_slug
    self.slug = self.username.gsub(/[^a-zA-Z0-9 -]/, '').gsub(' ', '-').downcase
  end

  def to_param
    self.slug
  end
end