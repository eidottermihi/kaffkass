class CreatePriceOfCoffees < ActiveRecord::Migration
  def change
    create_table :price_of_coffees do |t|
      t.float :price
      t.date :date

      t.timestamps
    end
  end
end
