class CreateBills < ActiveRecord::Migration
  def change
    create_table :bills do |t|
      t.float :value
      t.boolean :isPaid

      t.timestamps
    end
  end
end
