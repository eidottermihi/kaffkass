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
  validates :cash_position, :presence => true

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
      false
    else
      # User ist noch nicht angemeldet
      logger.debug "User[#{user.email}] meldet sich für CoffeeBox[ID=#{self.id}] an."
      self.participations.create(is_active: true, user_id: user.id)
      true
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
      true
    else
      # User ist nicht angemeldet
      false
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
    self.model_of_consumptions.where(user_id: user.id).limit(1).first
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
    prices
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
    consumes
  end

  # Liefert einen Hash mit zwei Arrays. Der Hash enthält für jeden abgerechneten Monat die Summe aller Einnahmen und
  # die Summe aller Ausgaben der Kaffeerunde.
  def get_expenses_data
    # Alle abgerechneten Monate ermitteln (sind alle Monate bis auf den letzten Eintrag mit Kaffeepreis)
    months = Array.new
    all_months = self.price_of_coffees.order("date DESC").all
    length = all_months.length
    if length > 0
      logger.debug all_months
      # Erstes Element entfernen = letzter Monat
      all_months.shift
      all_months.reverse!
      logger.debug all_months
    end
    all_months.each do |price|
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

    data
  end

  # Gibt die Anzahl der Teilnehmer der Kaffeerunde zurück
  def count_participants
    self.users.count
  end

  # Liefert ein Array, in dem für jeden Teilnehmer ein Hash enthalten ist. Der Hash enthält zwei Felder, name mit dem Namen des Teilnehmers,
  # und data mit einem Array, das den Wert seiner gesamten Anzahl an getrunkenen Tassen enthält.
  def get_consume_by_user
    # Consumption Bereich: Start der Kaffeerunde bis Ende des vorherigen Monats des aktuellsten Kaffeepreises
    min = self.created_at.beginning_of_day
    max_date = self.current_coffe_price_object.date
    max_date = max_date<<1
    max_date = max_date.end_of_month

    overall_consume = Array.new
    # Alle Teilnehmer der Kaffeerunde, Consumptions suchen und nrOfCups aufsummieren
    self.user_ids.each do |participant_id|
      hash = Hash.new
      username = User.find(participant_id).fullname
      hash["name"] = username
      logger.debug "## Summiere Kaffeetassen für User #{username}"
      sum = self.consumptions.where(user_id: participant_id, day: min .. max_date ).sum("numberOfCups")
      data = Array.new
      data.push(sum)
      hash["data"] = data
      logger.debug "## Kaffeetassen: #{sum}"
      overall_consume.push(hash)
    end
    overall_consume
  end

end
