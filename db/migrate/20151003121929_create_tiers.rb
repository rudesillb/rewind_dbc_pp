class CreateTiers < ActiveRecord::Migration
  def change
    create_table :tiers do |t|
      t.string :title, null: false
      t.integer :number, null: false, uniqueness: true
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
