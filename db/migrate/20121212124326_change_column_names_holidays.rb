class ChangeColumnNamesHolidays < ActiveRecord::Migration
  def change
    rename_column :holidays, :from, :beginning
    rename_column :holidays, :till, :till
  end
end
