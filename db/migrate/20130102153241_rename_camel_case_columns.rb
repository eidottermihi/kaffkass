class RenameCamelCaseColumns < ActiveRecord::Migration
  def change
    rename_column :bills, :isPaid, :is_paid
    rename_column :consumptions, :flagDisabled, :flag_disabled
    rename_column :consumptions, :flagTouched, :flag_touched
    rename_column :consumptions, :numberOfCups, :number_of_cups
  end
end
