class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.string :item
      t.float :value
      t.date :date

      t.timestamps
    end
  end
end
