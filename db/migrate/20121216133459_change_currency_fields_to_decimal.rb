class ChangeCurrencyFieldsToDecimal < ActiveRecord::Migration
  def change
    change_column :expenses, :value, :decimal, :precision => 8, :scale => 2
    change_column :bills, :value, :decimal, :precision => 8, :scale => 2
    change_column :price_of_coffees, :price, :decimal, :precision => 8, :scale => 2
  end
end
