class AddTiersUsers < ActiveRecord::Migration
  def change
    create_table :tiers_users, :id => false do |t|
      t.integer :tier_id
      t.integer :user_id
    end
  end
end
