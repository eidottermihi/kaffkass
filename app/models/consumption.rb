class Consumption < ActiveRecord::Base
  belongs_to :user
  belongs_to :coffee_box

  def create_month(date, current_user, coffee_box)
    from = date.beginning_of_month-1
    to = date.end_of_month-1
    tmp = from
    begin
      tmp += 1.day
      if (!current_user.consumptions.where(coffee_box_id: coffee_box, day: tmp).exists? && coffee_box.created_at < tmp+1)
        @temp_consumption = current_user.consumptions.build
        @temp_consumption.coffee_box=coffee_box
        @temp_consumption.flagTouched= false
        @temp_consumption.day= tmp
        @temp_consumption.flagDisabled= false
        if (current_user.model_of_consumptions.where(coffee_box_id: coffee_box).exists?)
          # Für die Kaffeerunde existiert ein Konsummodell
          # Anzahl der Tassen vorbelegen
          @model = current_user.model_of_consumptions.where(coffee_box_id: coffee_box).first;
          @temp_consumption.numberOfCups = get_cups_for_weekday(tmp, @model)
        else
          @temp_consumption.numberOfCups = 0
        end
        if Holiday.is_holiday tmp, current_user
          # Für den aktuellen Tag ist ein Urlaub hinterlegt
          # Tag als Urlaub markieren, Tassen auf 0 setzen
          @temp_consumption.numberOfCups = 0
          @temp_consumption.flag_holiday = true
        end

        current_user.consumptions << @temp_consumption
      end
      current_user.save
    end while tmp <= to
  end

  # Gibt in für ein Datum den Wert des Konsummodells für dieses Datum zurück.
  def get_cups_for_weekday(date, model)
    if (date.wday == 1)
      return model.mo
    elsif (date.wday == 2)
      return model.tue
    elsif (date.wday == 3)
      return model.wed
    elsif (date.wday == 4)
      return model.th
    elsif (date.wday == 5)
      return model.fr
    elsif (date.wday == 6)
      return model.sa
    elsif (date.wday == 0)
      return model.su
    else
      return 0
    end
  end

  # Gibt true zurück, wenn die Consumption schon abgerechnet wurde.
  def is_cleared?
    # Wenn für Monat/User/CoffeeBox schon eine Bill existiert, dann wurde die Consumption schon abgerechnet
    return Bill.where(user_id: self.user.id, coffee_box_id: self.coffee_box.id, date: self.day.beginning_of_month..self.day.end_of_month).exists?
  end

end
