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
  has_many :bills
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


  ## Methoden
  def fullname
    "#{firstname} #{lastname}"
  end

  def fullname_lastname_first
    "#{lastname}, #{firstname}"
  end

  def deliver_activation_instructions!
    reset_persistence_token!
    Notifier.activation_instructions(self).deliver
  end

  def deliver_welcome!
    reset_persistence_token!
    Notifier.welcome(self).deliver
  end

  def deliver_bill!(bill)
    Notifier.bill(bill,self).deliver
  end

  def activate!
    self.active = true
    save
  end

  # Gibt true zurück, wenn der User für die übergebene CoffeeBox angemeldet ist.
  # @param coffee_box CoffeeBox
  def participates?(coffee_box)
    # Kaffeerunden holen
    coffee_boxes = self.coffee_boxes.all
    coffee_boxes.each do |c|
      if c.id == coffee_box.id
        return true
      end
    end
    false
  end

  # Liefert ein Array mit noch nicht bezahlten Bills des Users zurück.
  def get_open_bills
    self.bills.where(is_paid: false)
  end
end
