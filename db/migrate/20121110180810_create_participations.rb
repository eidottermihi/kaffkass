class CreateParticipations < ActiveRecord::Migration
  def change
    create_table :participations do |t|
      t.integer :user_id
      t.integer :coffee_box_id
      t.boolean :is_active

      t.timestamps
    end
  end
end
