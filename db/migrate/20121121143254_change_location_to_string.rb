class ChangeLocationToString < ActiveRecord::Migration
  def change
    change_column :coffee_boxes, :location, :string
  end
end
