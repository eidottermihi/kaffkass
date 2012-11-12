class AddFksToZwischentabellen < ActiveRecord::Migration
  def change
    add_column :model_of_consumptions, :user_id, :integer
    add_column :model_of_consumptions, :coffee_box_id, :integer

    add_column :consumptions, :user_id, :integer
    add_column :consumptions, :coffee_box_id, :integer

    add_column :bills, :user_id, :integer
    add_column :bills, :coffee_box_id, :integer

    add_column :expenses, :user_id, :integer
    add_column :expenses, :coffee_box_id, :integer

    add_column :price_of_coffees, :coffee_box_id, :integer

  end
end
