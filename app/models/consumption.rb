class Consumption < ActiveRecord::Base
  belongs_to :user
  belongs_to :coffee_box

  ## Validierungen
  validates :number_of_cups, :numericality => {:only_integer => true}

  #Legt für einen Monat und User und Kaffee_box alle Consumptions an.
  #Die Konsumptions werden dabei abhängig von einem hinterlgeten Konsummodell und eingetragenem Urlaub vorbefüllt
  #Wird nicht ausgeführt, wenn der Monat vor dem Erstellungsdatum der coffee_box liegt oder die consumption für den Tag bereits existiert
  def self.create_month(date, current_user, coffee_box)
    from = date.beginning_of_month-1
    to = date.end_of_month-1
    tmp = from
    # Wenn für den nächsten Monat bereits ein Preis existiert, dann wurde der akt. Monat schon abgerechnet
    flag_abgerechnet = false
    next_month = date>>1
    if coffee_box.price_of_coffees.where(date: next_month.beginning_of_month .. next_month.end_of_month).exists?
      logger.debug "## Monat #{date} der CoffeeBox #{coffee_box.id} bereits abgeschlossen, alle Consumptions werden disabled."
      flag_abgerechnet = true
    end
    begin
      tmp += 1.day
      if !current_user.consumptions.where(coffee_box_id: coffee_box, day: tmp).exists? && coffee_box.created_at < tmp+1
        @temp_consumption = current_user.consumptions.build
        @temp_consumption.coffee_box=coffee_box
        @temp_consumption.flag_touched= false
        @temp_consumption.day= tmp
        @temp_consumption.flag_disabled= false
        if current_user.model_of_consumptions.where(coffee_box_id: coffee_box).exists?
          # Für die Kaffeerunde existiert ein Konsummodell
          # Anzahl der Tassen vorbelegen
          @model = current_user.model_of_consumptions.where(coffee_box_id: coffee_box).first
          @temp_consumption.number_of_cups = @model.get_cups_for_weekday(tmp)
        else
          @temp_consumption.number_of_cups = 0
        end
        if flag_abgerechnet
          # Monat wurde bereits abgeschlossen, alle Consumptions disablen
          @temp_consumption.flag_disabled = true
        end
        if Holiday.is_holiday tmp, current_user
          # Für den aktuellen Tag ist ein Urlaub hinterlegt
          # Tag als Urlaub markieren, Tassen auf 0 setzen
          @temp_consumption.number_of_cups = 0
          @temp_consumption.flag_holiday = true
        end

        current_user.consumptions << @temp_consumption
      end
      current_user.save
    end while tmp <= to
  end

  # Gibt true zurück, wenn die Consumption schon abgerechnet wurde.
  def is_cleared?
    # Wenn für Monat/User/CoffeeBox schon eine Bill existiert, dann wurde die Consumption schon abgerechnet
    Bill.where(user_id: self.user.id, coffee_box_id: self.coffee_box.id, date: self.day.beginning_of_month..self.day.end_of_month).exists?
  end

end
