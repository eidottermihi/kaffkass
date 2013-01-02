class ModelOfConsumption < ActiveRecord::Base
  belongs_to :coffee_box
  belongs_to :user

  validates :mo, :tue, :wed, :th, :fr, :sa, :su, :numericality => {:greater_than_or_equal_to => 0}
  validates :coffee_box_id, :presence => true
  validates :user_id, :presence => true


  # @param [ModelOfConsumption] consumption_model
  def self.update_model(consumption_model, params)
    # Änderungen speichern
    if consumption_model.update_attributes(params)
      # Alle Consumptions updaten, deren FlagTouched nicht gesetzt ist und für den Monat noch keine Bill vorhanden ist
      all_consumptions = Consumption.where(:user_id => consumption_model.user_id).all

      # Aussortieren der Tage, die schon abgerechnet wurden
      non_cleared_consumptions = Array.new
      all_consumptions.each do |c|
        if not c.is_cleared?
          non_cleared_consumptions.append(c)
        end
      end

      non_cleared_consumptions.each do |c|
        if not c.flag_touched?
          ## Tag wurde noch nicht manuell bearbeitet
          # -> Tag updaten
          c.number_of_cups = consumption_model.get_cups_for_weekday(c.day)
          c.save
        end
      end
      return true
    else
      return false
    end
  end

  # Gibt die Anzahl der Tassen zurück, die laut Konsummodell an diesem Tag konsumiert werden.
  def get_cups_for_weekday(date)
    if date.wday == 1
      self.mo
    elsif date.wday == 2
      self.tue
    elsif date.wday == 3
      self.wed
    elsif date.wday == 4
      self.th
    elsif date.wday == 5
      self.fr
    elsif date.wday == 6
      self.sa
    elsif date.wday == 0
      self.su
    else
       0
    end
  end
end
