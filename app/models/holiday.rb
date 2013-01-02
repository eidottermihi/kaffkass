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
    if holiday.save
      # Für den Zeitraum des Urlaubs Consumptions finden und flag_holiday setzen
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
    else
      return false
    end
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

  # Löscht den Urlaub, wenn möglich.
  def delete_holiday
    # Wenn Bills im Zeitraum des Urlaubs existieren, wurde ein Monat bereits abgeschlossen,
    # d.h. Urlaub kann nicht mehr gelöscht werden.
    min = self.beginning.beginning_of_month
    max = self.till.end_of_month
    if Bill.where(user_id: self.user.id, date: min..max).exists?
      false
    else
      self.destroy
      true
    end
  end

end
