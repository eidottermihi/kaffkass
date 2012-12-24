class PriceOfCoffee < ActiveRecord::Base
  belongs_to(:coffee_box)

  def createPriceForNextMonth(date, coffee_box, current_user)
    from = date.beginning_of_month
    to = date.end_of_month
    #Prüfe ob jetzt im Monat für jeden User der Coffeebox eine Bill existiert..
    #wenn ja dann stoße die Berechung des Preises für den neuen Monat an
    allBillsExist = true
    coffee_box.users.each do |user|
      if (!user.bills.where(coffee_box_id: coffee_box, date: from .. to).exists?)
        allBillsExist = false
      end
    end

    nextMonth = date>>1
    if (allBillsExist && !coffee_box.price_of_coffees.where(date: nextMonth.beginning_of_month .. nextMonth.end_of_month).exists?)
      #Passe neuen Kassenstand an
      einnahmen = 0
      coffee_box.bills.where(coffee_box_id: coffee_box, date: from .. to).each do |einnahme|
        einnahmen += einnahme.value
      end

      ausgaben = 0
      coffee_box.expenses.where(coffee_box_id: coffee_box, date: from .. to).each do |ausgabe|
        ausgaben += ausgabe.value
      end
      coffee_box.cash_position = coffee_box.cash_position - ausgaben + einnahmen
      coffee_box.save

      #berechne neuen Preis
      price_of_coffee = PriceOfCoffee.new
      price_of_coffee.date=date>>1
      price_of_coffee.price= self.calculate_new_price(current_user, date, coffee_box, ausgaben)
      price_of_coffee.coffee_box_id=coffee_box.id
      price_of_coffee.save
    end
  end


  def calculate_new_price(current_user, date, coffee_box, ausgaben)
    from = date.beginning_of_month
    to = date.end_of_month
    sumCups = current_user.consumptions.where(coffee_box_id: coffee_box, day: from .. to).sum(:numberOfCups)
    #TODO: Angestrebter Increment(increment) einführen   (atm fest auf 1€)
    new_price = ((ausgaben+1)-coffee_box.cash_position)/sumCups
    if (new_price > 0)
      return new_price
    else
      return 0
    end
  end

end
