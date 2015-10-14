class AddFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
      t.integer :friend_id
      t.references :user
      t.integer :tier
      t.datetime :seen

      t.timestamps
    end
  end
end
