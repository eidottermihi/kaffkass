class Holiday < ActiveRecord::Base
  belongs_to(:user)

  # Es darf maximal ein Holiday zu ein Start- und Enddatum vorhanden sein
  validates :beginning, :uniqueness => { scope: :user_id }
  validates :till, :uniqueness => { scope: :user_id }

  validates :user_id, :presence => true

  # Erzeugt einen neuen Urlaub. Liefert true zurück, wenn der Urlaub gespeichert wurde, false ansonsten.
  # @param  [Holiday] holiday
  def self.new_holiday(holiday)
    # Holiday speichern
    holiday.save
    # Für den Zeitraum des Urlaubs Consumptions finden und disablen
    participations = Participation.find_all_by_user_id(holiday.user_id)
    participations.each do |p|
      consumptions = Consumption.where(user_id: holiday.user_id, coffee_box_id: p.coffee_box).all
      consumptions.each do |c|
        if c.day.between? holiday.beginning, holiday.till
          # Consumption liegt im Urlaub
          c.flagDisabled=true
          c.numberOfCups = 0
          c.save
        end
      end
    end
  return true
  end
end
