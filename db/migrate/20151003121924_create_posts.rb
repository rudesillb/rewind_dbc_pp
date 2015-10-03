class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :content, null: false
      t.integer :user_id, null: false
      t.integer :tier_id, null: false

      t.timestamps
    end
  end
end
