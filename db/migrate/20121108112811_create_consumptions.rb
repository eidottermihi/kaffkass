class CreateConsumptions < ActiveRecord::Migration
  def change
    create_table :consumptions do |t|
      t.date :day
      t.integer :numberOfCups
      t.boolean :flagTouched

      t.timestamps
    end
  end
end
