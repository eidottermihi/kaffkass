class AddFlagAbgerechnetToExpenses < ActiveRecord::Migration
  def change
    add_column :expenses, :flag_abgerechnet, :boolean
  end
end
