class Bill < ActiveRecord::Base
  belongs_to(:user)
  belongs_to(:coffee_box)
end
