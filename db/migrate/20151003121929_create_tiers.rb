class CreateTiers < ActiveRecord::Migration
  def change
    create_table :tiers do |t|
      t.string :title, null: false
      t.integer :number, null: false
      t.references :user

      t.timestamps
    end
  end
end
