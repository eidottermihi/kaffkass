# encoding: utf-8
class CoffeeBoxesController < ApplicationController

  before_filter :require_user, :only => [:new, :create, :edit, :update, :destroy, :show]

  # Authorisiert automatisch jede Controller-Action
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
    # Tassenpreis speichern
    price = PriceOfCoffee.create(price: params[:price])
    if @coffee_box.save
      @coffee_box.price_of_coffees << price
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
    # Tassenpreis speichern
    price = PriceOfCoffee.create(price: params[:price])
    if @coffee_box.update_attributes(params[:coffee_box])
      @coffee_box.price_of_coffees << price
      redirect_to coffee_box_path(@coffee_box), :notice => "Änderungen erfolgreich gespeichert."
    else
      render "edit"
    end
  end

  def destroy
    @coffee_box = CoffeeBox.find(params[:id])
    @coffee_box.destroy
    redirect_to coffee_boxes_path, :notice => "Kaffeerunde wurde gelöscht."
  end

  def new_participate
    @coffee_box = CoffeeBox.find(params[:id])
    @model_of_consumption = ModelOfConsumption.new
  end

  def participate
    @coffee_box = CoffeeBox.find(params[:id])
    if @coffee_box.do_participate current_user
      redirect_to new_participate_path(@coffee_box, ModelOfConsumption.new)
    else
      redirect_to coffee_boxes_path, :alert => "Sie sind bereits für diese Kaffeerunde angemeldet."
    end
  end

  def unparticipate
    @coffee_box = CoffeeBox.find(params[:id])
    if @coffee_box.do_unparticipate current_user
      redirect_to coffee_boxes_path, :notice => "Erfolgreich abgemeldet."
    else
      redirect_to coffee_boxes_path, :notice => "Nicht möglich."
    end
  end
end
