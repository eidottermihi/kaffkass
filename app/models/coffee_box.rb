class CoffeeBox < ActiveRecord::Base
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
end
