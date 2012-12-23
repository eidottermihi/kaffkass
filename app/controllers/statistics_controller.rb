class StatisticsController < ApplicationController

  def consume_chart
    month = params[:month].to_i
    year = params[:year].to_i
    coffee_box = CoffeeBox.find(params[:coffee_box_id])

    data = coffee_box.get_coffee_cup_consume_data(month, year)

    respond_to do |format|
      format.json { render json: data}
    end
  end
end

