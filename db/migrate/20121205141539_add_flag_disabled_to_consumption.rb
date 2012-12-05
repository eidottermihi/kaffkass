class AddFlagDisabledToConsumption < ActiveRecord::Migration
  def change
    add_column :consumptions, :flagDisabled, :boolean
  end
end
