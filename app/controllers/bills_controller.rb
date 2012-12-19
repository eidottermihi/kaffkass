class BillsController < ApplicationController
  # GET /bills
  # GET /bills.json
  def index
    @coffee_box = CoffeeBox.find(params[:coffee_box_id])
    @bills = @coffee_box.bills.where(coffee_box_id: @coffee_box).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bills }
    end
  end

  # GET /bills/1
  # GET /bills/1.json
  def show
    @coffee_box = CoffeeBox.find(params[:coffee_box_id])
    @bill = @coffee_box.bills.where(coffee_box_id: @coffee_box).find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bill }
    end
  end

end