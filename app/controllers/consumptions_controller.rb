class ConsumptionsController < ApplicationController

  before_filter :require_user, :only => [:index]

  # GET /consumptions
  # GET /consumptions.json
  def index
    #überprüfe ob der User an der Kaffeerunde teilnimmt
    if (@current_user.participations.where(coffee_box_id: params[:coffee_box_id]).exists?)

      @coffee_box = CoffeeBox.find(params[:coffee_box_id])
      #Monat im Kalender setzen oder verändern
      @date = params[:month] ? Date.parse(params[:month]) : Date.today
      #Keinen Monat anzeigen der vor dem erstellungdatum liegt
      if (@date.month < @coffee_box.created_at.month && @date.year <= @coffee_box.created_at.year)
        @date = @date>>1
      end
      #Consumptions für den Monat erzeugen
      Consumption.new.create_month(@date, current_user, @coffee_box)
      @consumption = Consumption.new
      @consumptions = current_user.consumptions.where(coffee_box_id: @coffee_box).all
      respond_to do |format|
        format.html # index.html.erb
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to coffee_boxes_path, notice: 'You have to participate to the event' }
      end
    end
  end


  # GET /consumptions/1/edit
  def edit
    @coffee_box = CoffeeBox.find(params[:coffee_box_id])
    @consumption = current_user.consumptions.find(params[:id])
    respond_to do |format|
      format.js
      format.html # new.html.erb
    end
  end

  # PUT /consumptions/1
  # PUT /consumptions/1.json
  def update
    @consumption = current_user.consumptions.find(params[:id])
    @coffee_box = CoffeeBox.find(params[:coffee_box_id])
    @consumption.flagTouched = true
    respond_to do |format|
      if @consumption.update_attributes(params[:consumption])
        format.html { redirect_to coffee_box_consumptions_path, notice: 'Consumption was successfully updated.' }
        format.json { head :ok }
        format.js
      else
        format.html { render action: "edit" }
        format.json { render json: @consumption.errors, status: :unprocessable_entity }
      end
    end
  end


  def closeMonth
    @date = params[:month] ? Date.parse(params[:month]) : Date.today
    @coffee_box = CoffeeBox.find(params[:coffee_box_id])
    #abschließen nur möglich wenn auch ein price besteht
    if (@coffee_box.price_of_coffees.where(date: @date.beginning_of_month .. @date.end_of_month).exists?)
      Bill.new.createBillForMonth(@date, current_user, @coffee_box)
      PriceOfCoffee.new.createPriceForNextMonth(@date, @coffee_box)
    end
    respond_to do |format|
      format.html { redirect_to coffee_box_consumptions_url(month: @date.strftime("%Y/%m")) }
      format.json { head :no_content }
    end

  end

end
