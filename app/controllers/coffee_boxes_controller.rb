# encoding: utf-8
class CoffeeBoxesController < ApplicationController

  #before_filter :require_user, :only => [:new, :create]
  load_and_authorize_resource

  def index
    @coffee_boxes = CoffeeBox.all
  end

  def new
    @coffee_box = CoffeeBox.new
    # renders new
  end

  def create
    @coffee_box = CoffeeBox.new(params[:coffee_box])
    # Admin der Kaffeerunde ist Ersteller der Kaffeerunde
    @coffee_box.admin=current_user
    if @coffee_box.save
      flash[:notice] = "Kaffeerunde erfolgreich angelegt."
      redirect_to coffee_boxes_path
    else
      render "new"
    end
  end

  def show
    @coffee_box = CoffeeBox.find(params[:id])
    if @coffee_box
      render "show"
    else
      flash[:alert] = "Kaffeerunde nicht vorhanden."
      redirect_to coffee_boxes_path
    end
  end

  def edit
    @coffee_box = CoffeeBox.find(params[:id])
    render "edit"
  end

  def update
    @coffee_box = CoffeeBox.find(params[:id])
    if @coffee_box.update_attributes(params[:coffee_box])
      redirect_to coffee_box_path(@coffee_box), :notice => "Änderungen erfolgreich gespeichert."
    else
      render "edit"
    end
  end
end
