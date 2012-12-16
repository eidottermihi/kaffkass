class Holiday < ActiveRecord::Base
  belongs_to(:user)

  # Es darf maximal ein Holiday zu ein Start- und Enddatum vorhanden sein
  validates :beginning, :uniqueness => {scope: :user_id}
  validates :till, :uniqueness => {scope: :user_id}

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
        if not c.flagDisabled?
        # Tag wurde noch nicht abgerechnet, d.h. noch nicht disabled
          if c.day.between? holiday.beginning, holiday.till
            # Consumption liegt im Urlaub
            c.flag_holiday = true
            c.numberOfCups = 0
            c.save
          end
        end
      end
    end
    return true
  end

  # Prüft, ob der übergebene Tag ein Urlaubstag des übergebenen Users ist.
  # @param [Date] day der Tag
  # @param [User] user der User
  def self.is_holiday(day, user)
    if user.holidays.where("beginning <= :day and till >= :day", {day: day}).exists?
      return true
    else
      return false
    end
  end
end
