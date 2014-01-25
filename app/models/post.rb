class Post < ActiveRecord::Base
  include Voteable
  include Sluggable
  default_scope order('created_at DESC')

  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'
  has_many :comments
  has_many :post_categories
  has_many :categories, through: :post_categories

  validates :title, presence: true, length: {minimum: 3}
  validates :url, presence: true, uniqueness: true
  validates :description, presence: true, length: {minimum: 5}

  sluggable_column :title

  def response_post
    { title: self.title, url: self.url, description: self.description }
  end
end