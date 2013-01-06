class AddSaldoToCoffeeBox < ActiveRecord::Migration
  def change
    add_column :coffee_boxes, :saldo, :decimal, :precision => 8, :scale => 2, default:0
  end
end
