class ChangeCoffeeBoxTimeFromDateTimeToTime < ActiveRecord::Migration
  def change
    change_column :coffee_boxes, :time, :time
  end
end
