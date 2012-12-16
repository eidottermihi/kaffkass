class AddFlagHolidayToConsumption < ActiveRecord::Migration
  def change
    add_column "consumptions", "flag_holiday", :boolean
  end
end
