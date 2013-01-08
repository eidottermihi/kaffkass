# encoding: utf-8
class PriceOfCoffee < ActiveRecord::Base

  belongs_to(:coffee_box)

  validates :date, :presence => true
  validates :price, :presence => true
  validates :price, :numericality => {:greater_than_or_equal_to => 0}

  # Erzeugt einen neuen Tassenpreis. Der neue Tassenpreis wird nur erzeugt, wenn alle Teilnehmer der Kaffeerunde
  # den akt. Monat abgeschlossen haben, d.h. das für jeden Teilnehmer für den letzten Monat eine Bill existiert.
  def self.create_price_for_next_month(date, coffee_box)
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
      # Ausgaben aufsummieren, Expense als abgerechnet markieren
      ausgaben = 0
      coffee_box.expenses.where(coffee_box_id: coffee_box, date: from .. to,flag_abgerechnet: false).each do |ausgabe|
        logger.debug "## Ausgabe #{ausgabe.value}"
        ausgaben += ausgabe.value
        ausgabe.flag_abgerechnet = true
        ausgabe.save
      end
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
  def self.calculate_new_price(date, coffee_box, ausgaben)
    logger.debug "## Berechne neuen Preis für CoffeeBox #{coffee_box.id}"
    from = date.beginning_of_month
    to = date.end_of_month
    # Tassenkonsum des letzten Monats herausfinden
    sum_cups = coffee_box.consumptions.where(day: from .. to).sum(:number_of_cups)
    # Summe offener Rechnungen
    sum_open_bills = coffee_box.bills.where(is_paid: false).sum(:value)
    # Annahme: Ausgaben bleiben im neuen Monat gleich
    # Annahme: Tassenkonsum bleibt im neuen Monat gleich
    # Annhame: offene Rechnungen werden noch bezahlt
    # Neuer Tassenpreis: ((Saldo) - (Kassenstand + Summe offener Rechnungen(beinhaltet Ausgabe) )) / Anzahl Tassen letzter Monat
    new_price = ((coffee_box.saldo) - (coffee_box.cash_position + sum_open_bills)) / sum_cups
    logger.debug "## Ausgaben: #{ausgaben}"
    logger.debug "## Saldo: #{coffee_box.saldo}"
    logger.debug "## Kassenstand: #{coffee_box.cash_position}"
    logger.debug "## Neuer Preis: #{new_price}"
    if new_price > 0
      new_price
    else
      0
    end
  end

end
