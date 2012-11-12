class AddFkUserIdToCoffeBox < ActiveRecord::Migration
  def change
    add_column :coffee_boxes, :user_id, :integer
  end
end
