class Bill < ActiveRecord::Base
  belongs_to :user
  belongs_to :coffee_box


  validates :value, :presence => true

  #Erzeugt eine Rechnung für einen abgerechneten Monat und versendet sie an den User.
  #Setzte alle abgerechneten Consumptions auf disabled.
  def self.create_bill_for_month(date, current_user, coffee_box)
    from = date.beginning_of_month
    to = date.end_of_month
    if not current_user.bills.where(coffee_box_id: coffee_box, date: from .. to).exists?
      @bill = current_user.bills.build
      @bill.coffee_box=coffee_box
      @bill.is_paid = false
      @bill.date = date

      sum_cups = current_user.consumptions.where(coffee_box_id: coffee_box, day: from .. to).sum(:number_of_cups)
      sum_ausgaben = current_user.expenses.where(coffee_box_id: coffee_box, flag_abgerechnet: nil).sum(:value)
      price = coffee_box.price_of_coffees.where(date: from .. to).first
      #Preis berechnen
      @bill.value = sum_cups * price.price - sum_ausgaben
      if @bill.save
        current_user.deliver_bill!(@bill)
        #Alle betroffenen Consumptions auf disabled setzen
        tmp = (from-1)
        begin
          tmp += 1.day
          if current_user.consumptions.where(coffee_box_id: coffee_box, day: tmp).exists?
            @temp_consumption = current_user.consumptions.where(coffee_box_id: coffee_box, day: tmp).first
            @temp_consumption.flag_disabled = true
            @temp_consumption.save
          end
        end while tmp <= (to-1)
      end
    end
  end
end

