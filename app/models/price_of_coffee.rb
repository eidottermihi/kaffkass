class PriceOfCoffee < ActiveRecord::Base
  belongs_to(:coffee_box)
end
