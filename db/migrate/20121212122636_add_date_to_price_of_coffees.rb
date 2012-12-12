class AddDateToPriceOfCoffees < ActiveRecord::Migration
  def change
    add_column :price_of_coffees, :date, :date
  end
end
