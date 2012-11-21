class UserSession < Authlogic::Session::Base
  def getCurrentCoffeeBox
    #TODO: Coffeebox aus Session setzen
    return @coffee_box = CoffeeBox.find(1);
  end
end
