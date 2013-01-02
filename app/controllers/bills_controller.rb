class BillsController < ApplicationController

  before_filter :require_user, :only => [:index, :mark_as_paid]


  def index
    @coffee_box = CoffeeBox.find(params[:coffee_box_id])
    @bills = @coffee_box.bills.where(coffee_box_id: @coffee_box).all
    authorize! :index_bills, @coffee_box

    respond_to do |format|
      format.html
      format.json { render json: @bills }
    end
  end

  def mark_as_paid

    @coffee_box = CoffeeBox.find(params[:coffee_box_id])
    @bill = @coffee_box.bills.where(coffee_box_id: @coffee_box).find(params[:id])

    authorize! :mark_as_paid, @bill

    @bill.isPaid=true
    @bill.save

    redirect_to coffee_box_bills_path(@coffee_box.id), notice: "Rechnung wurde als bezahlt markiert."
  end

end