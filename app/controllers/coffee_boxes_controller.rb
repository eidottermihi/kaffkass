class CoffeeBoxesController < ApplicationController

  def index
    @coffee_boxes = CoffeeBox.all
  end

  def new
    @coffee_box = CoffeeBox.new
    # renders new
  end

  def create
    @coffee_box = CoffeeBox.new(params[:coffee_box])
    if @coffee_box.save
      flash[:notice] = "Kaffeerunde erfolgreich angelegt."
      redirect_to coffee_boxes_path
    else
      flash[:alert] = "Konnte nicht gespeichert werden."
      render "new"
    end
  end
end
