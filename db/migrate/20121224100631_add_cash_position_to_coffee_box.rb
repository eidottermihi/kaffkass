class AddCashPositionToCoffeeBox < ActiveRecord::Migration
  def change
    add_column :coffee_boxes, :cash_position, :decimal, :precision => 8, :scale => 2, default:0
  end
end
