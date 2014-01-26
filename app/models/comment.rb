class Comment < ActiveRecord::Base
  include Voteable

  default_scope { order('total_votes DESC, created_at DESC') }

  belongs_to :post
  belongs_to :creator, foreign_key: 'user_id', class_name: 'User'

  validates :body, presence: true, length: {minimum: 5}
end