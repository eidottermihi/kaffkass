class Expense < ActiveRecord::Base
  belongs_to(:user)
  belongs_to(:coffee_box)

  validates :item, :presence => true
  validates :value, :presence => true
  validates :value, :numericality => {greater_than: 0}
  validates :date, :presence => true
end
