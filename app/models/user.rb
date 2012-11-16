class User < ActiveRecord::Base
  #Authlogic: defining that this is the model to use for logging in and out
  acts_as_authentic do |c|
  end # block optional
  
  # Validierung
  validates :firstname, :presence => true
  validates :lastname, :presence => true
  validates :email, :presence => true, :uniqueness => true

  ## Beziehungen
  # Rechnungen
  has_many(:bills)
  # Zwischentabelle für Teilnahme an Kaffeerunden
  has_many :participations
  # Direkter Zugriff auf alle Kaffeerunden, an denen der User teilnimmt
  has_many :coffee_boxes, :through => :participations
  # Kaffeerunden, die der User verwaltet
  has_many :administrated_coffee_boxes, :class_name => "CoffeeBox"
  # Kaffeeverbrauch
  has_many(:consumptions)
  # Kaffeeausgaben
  has_many(:expenses)
  # Urlaub
  has_many(:holidays)
  # Konsummodell
  has_many(:model_of_consumptions)
end
