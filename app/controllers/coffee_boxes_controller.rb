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

  def participate
    @coffee_box = CoffeeBox.find(params[:id])
    if @coffee_box.users.exists?(current_user.id)
      #@coffee_box.users.delete(current_user.id)
      redirect_to coffee_boxes_path, :alert => "Sie sind bereits für diese Kaffeerunde angemeldet."
    else
      # Neue Teilnahme erzeugen
      @coffee_box.participations << Participation.create(user_id: current_user.id, coffee_box_id: @coffee_box.id, is_active: true)
      redirect_to coffee_boxes_path, :notice => "Sie wurden für die Kaffeerunde angemeldet."
    end

    #redirect_to coffee_boxes_path, :notice => "participate"
  end

  def unparticipate

  end
end
