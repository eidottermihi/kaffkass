class ModelOfConsumption < ActiveRecord::Base
  attr_accessible :mo, :tue, :wed, :th, :fr, :sa, :su
  belongs_to(:coffee_box)
  belongs_to(:user)

  validates :mo, :tue, :wed, :th, :fr, :sa, :su, :numericality => {:greater_than_or_equal_to  => 0}
  validates :coffee_box_id, :presence => true
  validates :user_id, :presence => true
end
