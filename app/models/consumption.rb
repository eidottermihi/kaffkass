class Consumption < ActiveRecord::Base
  belongs_to(:user)
  belongs_to(:coffee_box)

  def createMonth(date,current_user,coffee_box)
    from = date.beginning_of_month-1
    to =  date.end_of_month-1
    tmp = from
    begin
      tmp += 1.day
      if(!current_user.consumptions.where(coffee_box_id:coffee_box,day:tmp).exists?)
      @temp_consumption = current_user.consumptions.build
      @temp_consumption.coffee_box=coffee_box
      @temp_consumption.day = tmp
      @temp_consumption.numberOfCups = 0
      current_user.consumptions << @temp_consumption
      end
      current_user.save
    end while tmp <= to
  end

end
