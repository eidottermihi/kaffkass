class UserSession < Authlogic::Session::Base
  def getCurrentCoffeeBox
    return @coffee_box = CoffeeBox.find(1);
  end
end
