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
  has_many(:consumptions)
  # Kaffeepreis
  has_many(:price_of_coffees)

  ## Validierungen
  validates :location, :presence => true
  validates :time, :presence => true


  ## Methoden
  def current_coffee_price
    self.price_of_coffees.order("created_at DESC").first.price
  end

  def current_coffe_price_object
    self.price_of_coffees.order("created_at DESC").first
  end
end
