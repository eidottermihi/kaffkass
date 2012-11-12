class ModelOfConsumption < ActiveRecord::Base
  belongs_to(:coffee_box)
  belongs_to(:user)
end
