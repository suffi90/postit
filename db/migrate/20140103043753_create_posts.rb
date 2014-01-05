class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.string :url
      t.text :description
    end
  end
end

### Alternative syntax for change method
# def up
#   create_table :posts do |t|
#   end
# end
# roll back table, opposite up method
# def down
#   drop_table :posts
# end