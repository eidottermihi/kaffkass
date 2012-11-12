class CreateHolidays < ActiveRecord::Migration
  def change
    create_table :holidays do |t|
      t.date :from
      t.date :till

      t.timestamps
    end
  end
end
