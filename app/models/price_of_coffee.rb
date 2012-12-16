class PriceOfCoffee < ActiveRecord::Base
  belongs_to(:coffee_box)

  def createPriceForNextMonth(date, coffee_box)
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
      price_of_coffee = PriceOfCoffee.new
      price_of_coffee.date=date>>1
      #TODO: stoße Berechnung des neuen Preises an
      price_of_coffee.price= 1337
      price_of_coffee.coffee_box_id=coffee_box.id
      price_of_coffee.save
    end
  end

end
