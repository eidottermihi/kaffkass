class ChangeDateToTimestampInPriceOfCoffees < ActiveRecord::Migration
  def change
    # Spalte date ist überflüssig, da wir dafür genausogut created_at verwenden können
    remove_column :price_of_coffees, :date
  end
end
