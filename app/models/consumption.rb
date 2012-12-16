class Consumption < ActiveRecord::Base
  belongs_to(:user)
  belongs_to(:coffee_box)

  def createMonth(date, current_user, coffee_box)
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
          @temp_consumption.numberOfCups = getCupsForWeekday(tmp, @model)
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

  def getCupsForWeekday(date, model)

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

end
