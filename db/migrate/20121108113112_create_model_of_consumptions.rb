class CreateModelOfConsumptions < ActiveRecord::Migration
  def change
    create_table :model_of_consumptions do |t|
      t.integer :mo
      t.integer :tue
      t.integer :wed
      t.integer :th
      t.integer :fr
      t.integer :sa
      t.integer :su

      t.timestamps
    end
  end
end
