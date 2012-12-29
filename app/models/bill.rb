class Bill < ActiveRecord::Base
  belongs_to :user
  belongs_to :coffee_box


  validates :value, :presence => true

  def create_bill_for_month(date, current_user, coffee_box)
    from = date.beginning_of_month
    to = date.end_of_month
    if (!current_user.bills.where(coffee_box_id: coffee_box, date: from .. to).exists?)
      @bill = current_user.bills.build
      @bill.coffee_box=coffee_box
      @bill.isPaid = false
      @bill.date = date

      sumCups = current_user.consumptions.where(coffee_box_id: coffee_box, day: from .. to).sum(:numberOfCups)
      price = coffee_box.price_of_coffees.where(date: from .. to).first
      @bill.value = sumCups * price.price
      if (@bill.save)
        current_user.deliver_bill!(@bill)
        tmp = (from-1)
        begin
          tmp += 1.day
          if (current_user.consumptions.where(coffee_box_id: coffee_box, day: tmp).exists?)
            @temp_consumption = current_user.consumptions.where(coffee_box_id: coffee_box, day: tmp).first
            @temp_consumption.flagDisabled = true
            @temp_consumption.save
          end
        end while tmp <= (to-1)
      end
    end
  end
end

