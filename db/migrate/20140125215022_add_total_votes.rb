class AddTotalVotes < ActiveRecord::Migration
  def change
    add_column :posts, :total_votes, :integer
    add_column :comments, :total_votes, :integer
  end
end
