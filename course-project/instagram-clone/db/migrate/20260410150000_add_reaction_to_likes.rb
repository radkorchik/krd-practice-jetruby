class AddReactionToLikes < ActiveRecord::Migration[8.1]
  def change
    add_column :likes, :reaction, :integer, null: false, default: 1
  end
end
