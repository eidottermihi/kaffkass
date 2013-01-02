# encoding: utf-8
class PriceOfCoffee < ActiveRecord::Base

  belongs_to(:coffee_box)

  validates :date, :presence => true
  validates :price, :presence => true
  validates :price, :numericality => {:greater_than_or_equal_to => 0}

  # Erzeugt einen neuen Tassenpreis. Der neue Tassenpreis wird nur erzeugt, wenn alle Teilnehmer der Kaffeerunde
  # den akt. Monat abgeschlossen haben, d.h. das für jeden Teilnehmer für den letzten Monat eine Bill existiert.
  def create_price_for_next_month(date, coffee_box)
    from = date.beginning_of_month
    to = date.end_of_month
    #Prüfe ob jetzt im Monat für jeden User der Coffeebox eine Bill existiert..
    #wenn ja dann stoße die Berechung des Preises für den neuen Monat an
    all_bills_exist = true
    coffee_box.users.each do |user|
      if not user.bills.where(coffee_box_id: coffee_box, date: from .. to).exists?
        all_bills_exist = false
      end
    end

    next_month = date>>1
    # Wenn alle Teilnehmer den Monat abgeschlossen haben und noch kein Preis für den nächsten Monat berechnet wurde, berechne ihn
    if all_bills_exist and not coffee_box.price_of_coffees.where(date: next_month.beginning_of_month .. next_month.end_of_month).exists?
      #Passe neuen Kassenstand an
      # Einnahmen aus Rechnungen summieren
      einnahmen = 0
      coffee_box.bills.where(coffee_box_id: coffee_box, date: from .. to).each do |einnahme|
        einnahmen += einnahme.value
      end
      # Ausgaben aufsummieren, Expense als abgerechnet markieren
      ausgaben = 0
      coffee_box.expenses.where(coffee_box_id: coffee_box, flag_abgerechnet: false).each do |ausgabe|
        ausgaben += ausgabe.value
        ausgabe.flag_abgerechnet = true
        ausgabe.save
      end
      # Neuer Kassenstand = Alter Kassenstand - Ausgaben + Einnahmen
      coffee_box.cash_position = coffee_box.cash_position - ausgaben + einnahmen
      coffee_box.save

      # Berechne neuen Preis
      price_of_coffee = PriceOfCoffee.new
      price_of_coffee.date = date>>1
      price_of_coffee.price = self.calculate_new_price(date, coffee_box, ausgaben)
      price_of_coffee.coffee_box_id = coffee_box.id
      price_of_coffee.save
    end
  end


  # Berechnet anhand der Ausgaben des letzten Monats den neuen Tassenpreis.
  def calculate_new_price(date, coffee_box, ausgaben)
    logger.debug "## Berechne neuen Preis für CoffeeBox #{coffee_box.id}"
    from = date.beginning_of_month
    to = date.end_of_month
    # Tassenkonsum des letzten Monats herausfinden
    sum_cups = coffee_box.consumptions.where(day: from .. to).sum(:numberOfCups)
    # Annahme: Ausgaben bleiben im neuen Monat gleich
    # Annahme: Tassenkonsum bleibt im neuen Monat gleich
    # Neuer Tassenpreis: ((Ausgaben + Saldo) - Kassenstand ) / Anzahl Tassen letzter Monat
    new_price = ((ausgaben + coffee_box.saldo) - coffee_box.cash_position) / sum_cups
    logger.debug "## Neuer Preis: #{new_price}"
    if new_price > 0
      new_price
    else
      0
    end
  end

end
