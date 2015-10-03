class CreateTiers < ActiveRecord::Migration
  def change
    create_table :tiers do |t|
      t.string :title
      t.integer :number, null: false
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
