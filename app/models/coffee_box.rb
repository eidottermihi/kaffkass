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
    self.price_of_coffees.order("created_at DESC").first.price
  end

  # Gibt den aktuellen Tassenpreis als Objekt der Klasse PriceOfCoffee zurück.
  def current_coffe_price_object
    self.price_of_coffees.order("created_at DESC").first
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
end
