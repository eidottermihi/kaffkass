class ModelOfConsumption < ActiveRecord::Base
  attr_accessible :mo, :tue, :wed, :th, :fr, :sa, :su
  belongs_to(:coffee_box)
  belongs_to(:user)

  validates :mo, :tue, :wed, :th, :fr, :sa, :su, :numericality => {:greater_than_or_equal_to => 0}
  validates :coffee_box_id, :presence => true
  validates :user_id, :presence => true


  # @param [ModelOfConsumption] consumption_model
  def self.update_model(consumption_model, params)
    # Änderungen speichern
    if consumption_model.update_attributes(params)
      # Alle Consumptions updaten, deren FlagTouched nicht gesetzt ist und für den Monat noch keine Bill vorhanden ist
      # TODO Prüfen, ob Consumption schon abgerechnet wurde!!!
      consumptions = Consumption.where(:user_id => consumption_model.user_id).all

      consumptions.each do |c|
        if not c.flagTouched?
          ## Tag wurde noch nicht manuell bearbeitet
          c.numberOfCups = c.getCupsForWeekday(c.day, consumption_model)
          c.save
        end
      end
      return true
    else
      return false
    end

  end
end
