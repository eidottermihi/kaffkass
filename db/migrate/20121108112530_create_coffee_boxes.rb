class CreateCoffeeBoxes < ActiveRecord::Migration
  def change
    create_table :coffee_boxes do |t|
      t.text :location
      t.datetime :time
      t.text :description

      t.timestamps
    end
  end
end
