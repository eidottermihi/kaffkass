class BillsController < ApplicationController

  before_filter :require_user, :only => [:index, :mark_as_paid]

  #TODO: cancan

  def index
    @coffee_box = CoffeeBox.find(params[:coffee_box_id])
    @bills = @coffee_box.bills.where(coffee_box_id: @coffee_box).all

    respond_to do |format|
      format.html
      format.json { render json: @bills }
    end
  end

  def mark_as_paid
    @coffee_box = CoffeeBox.find(params[:coffee_box_id])
    @bill = @coffee_box.bills.where(coffee_box_id: @coffee_box).find(params[:id])

    @bill.isPaid=true
    @bill.save

    redirect_to coffee_box_bills_path(@coffee_box.id)
  end

end