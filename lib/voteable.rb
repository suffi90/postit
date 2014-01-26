module Voteable
  extend ActiveSupport::Concern

  included do
    before_save :generate_total_votes!
    has_many :votes, as: :voteable
  end

  def generate_total_votes!
    self.total_votes = up_votes - down_votes
  end

  def up_votes
    self.votes.where(vote: true).size
  end

  def down_votes
    self.votes.where(vote: false).size
  end
end