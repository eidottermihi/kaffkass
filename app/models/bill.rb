class Bill < ActiveRecord::Base
  belongs_to(:user)
  belongs_to(:coffee_box)

  validates :value, :presence => true
  validates :isPaid, :presence => true
end
