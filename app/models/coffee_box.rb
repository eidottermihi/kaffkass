# encoding : utf-8

class CoffeeBox < ActiveRecord::Base
  ## Beziehungen
  # Admin
  belongs_to :admin, :class_name => "User", foreign_key: "user_id"
  # Zwischtabelle für Teilnehmer
  has_many :participations
  # Teilnehmer der Kaffeerunde
  has_many :users, :through => :participations
  # Rechnungen zur Kaffeerunde
  has_many(:bills)
  # Konsummodelle zur Kaffeerunde
  has_many(:model_of_consumptions)
  # Ausgaben zur Kaffeerunde
  has_many(:expenses)
  # Verbrauch
  has_many :consumptions
  # Kaffeepreis (Einträge werden gelöscht wenn Kaffeerunde gelöscht wird)
  has_many :price_of_coffees, dependent: :destroy

  ## Validierungen
  validates :location, :presence => true
  validates :time, :presence => true


  ## Methoden

  # Gibt den aktuellen Tassenpreis als Zahl zurück
  def current_coffee_price
    self.price_of_coffees.order("date DESC").first.price
  end

  # Gibt den aktuellen Tassenpreis als Objekt der Klasse PriceOfCoffee zurück.
  def current_coffe_price_object
    self.price_of_coffees.order("date DESC").first
  end

  # Führt eine Anmeldung durch. Gibt true zurück, wenn Anmeldung erfolgreich war. Bei einer erfolgreichen Anmeldung
  # existiert ein Eintrag in der Tabelle Participations.
  def do_participate(user)
    if self.users.exists?(user.id)
      # User ist bereits angemeldet
      return false
    else
      # User ist noch nicht angemeldet
      logger.debug "User[#{user.email}] meldet sich für CoffeeBox[ID=#{self.id}] an."
      self.participations.create(is_active: true, user_id: user.id)
      return true
    end
  end

  # Führt eine Abmeldung durch. Gibt true zurück, wenn die Abmeldung erfolgreich war. Nach einer erfolgreichen Abmeldung
  # existiert in der Tabelle Participations kein Eintrag mehr.
  # @param [User] user der abgemeldet werden soll
  def do_unparticipate(user)
    if self.users.exists?(user.id)
      # User ist aktuell angemeldet, Abmeldung kann erfolgen
      # Participation löschen
      logger.debug "User[ID=#{user.id}] meldet sich von CoffeeBox[ID=#{self.id}] ab."
      self.users.delete(user)
      # Model löschen wenn vorhanden
      ModelOfConsumption.where(coffee_box_id: self.id, user_id: user.id).all.each do |c|
        logger.debug "Lösche ModelOfConsumption[ID=#{c.id}]."
        c.destroy
      end

      return true
    else
      # User ist nicht angemeldet
      return false
    end
  end

  # Liefert eine Liste mit allen Kaffeerunden zurück, für die der übergebene User angemeldet ist.
  # Hinweis: Klassenmethode
  # @param [User] user
  def self.get_coffee_boxes(user)
    user = User.find(user.id)
    participations = user.participations.where(is_active: true)
    coffee_boxes = Array.new
    participations.each {
        |p| coffee_boxes.append p.coffee_box
    }
    return coffee_boxes
  end

  # Liefert das Konsummodell für den User für die aktuelle Kaffeerunde zurück, oder nil wenn
  # kein Konsummodell hinterlegt ist.
  # @param [User] user der aktuell angemeldete User
  def get_consumption_model(user)
    consumption_model = ModelOfConsumption.where(:user_id => user.id, :coffee_box_id => self.id).limit(1).first
    return consumption_model
  end

  # Liefert eine Array mit Daten zu den Tassenpreis der Kaffeerunde.
  def get_cup_price_data
    prices = Array.new
    self.price_of_coffees.all.each do |p|
      price = Array.new
      # X-Wert ist Zeitstempel, ab wann der Tassenpreis gültig ist (für Highcharts unformatiert in ms seit 1970, UTC) => Addiere 1 Stunden für Zeitzone Berlin
      x_value = p.date.to_time.to_i * 1000 + (1000 * 60 * 60)
      price.append(x_value)
      # Y-Value ist der Preis
      y_value = p.price.to_f
      price.append(y_value)
      prices.append(price)
    end
    return prices
  end

  # Liefert ein Array mit Daten zum Tassenkonsum dieser Kaffeerunde für einen Monat.
  def get_coffee_cup_consume_data(month, year)
    day_min = Date.new(year, month, 1)
    day_max = day_min.end_of_month
    consumes = Array.new
    c = self.consumptions.select("date(day) as day, sum(numberOfCups) as total_cups").where("day >= :day_min and day <= :day_max", {day_min: day_min, day_max: day_max}).group("date(day)")
    c.each do |res|
      consume = Array.new
      # X-Wert ist Zeitstempel des Tages (in ms, UTC) => Addiere 1 Stunden für Zeitzone Berlin
      x_value = res.day.to_time.to_i * 1000 + (1000 * 60 * 60)
      consume.append(x_value)
      # Y-Wert ist die Anzahl der konsumierten Tassen an diesem Tag
      y_value = res.total_cups
      consume.append(y_value)

      consumes.append(consume)
    end
    return consumes
  end

  # Liefert einen Hash mit zwei Arrays. Der Hash enthält für jeden abgerechneten Monat die Summe aller Einnahmen und
  # die Summe aller Ausgaben der Kaffeerunde.
  def get_expenses_data
    # Alle abgerechneten Monate ermitteln (sind Monate mit Kaffeepreis)
    months = Array.new
    self.price_of_coffees.each do |price|
      months.append price.date
    end
    data = Hash.new
    expenses = Array.new
    incomes = Array.new
    months.each do |month|
      expense = Array.new
      income = Array.new
      # Ausgaben für diesen Monat summieren
      total = self.expenses.where(date: month.beginning_of_month .. month.end_of_month).sum("value")
      expense.append(month.to_time.to_i * 1000 + (1000 * 60 * 60))
      expense.append(total.to_f)
      expenses.append(expense)

      # Einnahmen für jeden Monat berechnen = Tassenpreis für Monat * konsumierte Tassen im Monat
      cup_data = self.get_coffee_cup_consume_data(month.month, month.year)
      cups_per_month = 0
      cup_data.each do |cups_per_day|
        cups_per_month += cups_per_day[1]
      end

      # Tassenpreis für aktuellen Monat
      price = self.price_of_coffees.where(date: month.beginning_of_month..month.end_of_month).first.price

      income.append(month.to_time.to_i * 1000 + (1000 * 60 * 60))
      income.append((cups_per_month * price).to_f)

      incomes.append(income)

    end
    data[:expenses] = expenses
    data[:incomes] = incomes

    return data
  end

  def close_latest_month_for_all
    # TODO: Monat nur abschließen, wenn in dem Monat auch bereits Consumptions vorhanden sind
    # TODO: Fehler, wenn Monat abgeschloßen werden soll an dem ein einzelnern User noch keine Consumptions hat
    # Monat suchen, in dem für nicht alle Teilnehmer eine Bill besteht
    if Bill.where(:coffee_box_id => self.id).order("date DESC").exists?
      logger.debug "## Es bestehen bereits Bills für die CoffeeBox."
      start_date = self.created_at.to_date
      from = start_date.beginning_of_month
      to = start_date.end_of_month
      month_found = false
      logger.debug "## Starte Suche mit Monat #{start_date}"
      while (month_found == false) do
        logger.debug "## From: #{from}"
        logger.debug "## To: #{to}"
        self.users.all.each do |user|
          logger.debug "##Suche Bill für User #{user.id}"
          if not user.bills.where(date: from..to).exists?
            # Monat gefunden, an dem für einen User noch keine Rechnung exisitiert
            logger.debug "##User #{user.id} hat im Monat #{start_date} noch keine Bill."
            month_found = true
          end
        end
        if not month_found
          logger.debug "##Im Monat #{start_date} hat jeder User bereits eine Bill"
          start_date = start_date >> 1
          from = start_date.beginning_of_month
          to = start_date.end_of_month
          logger.debug "##Suche weiter im Monat #{start_date}"
        end
      end
      self.users.all.each do |user|
        logger.debug "## Erzeuge Bill für User #{user.id}, CoffeeBox #{self.id} und Monat #{start_date}"
        Bill.new.create_bill_for_month(start_date, user, self)
      end
      # Neuen Preis berechnen
      PriceOfCoffee.new.create_price_for_next_month(start_date, self)
      return start_date
    else
      # Es besteht noch überhaupt keine Bill -> ersten Monat abschließen
      # Für jeden Teilnehmer eine neue Bill für den ersten Monat erstellen
      logger.debug "Es existieren keine Bills für die CoffeeBox, schließe ersten Monat ab."
      self.users.all.each do |user|
        Bill.new.create_bill_for_month(self.created_at, user, self)
      end
      # Neuen Preis berechnen
      PriceOfCoffee.new.create_price_for_next_month(self.created_at.to_date, self)
    end
  end

end
