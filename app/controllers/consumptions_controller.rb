class ConsumptionsController < ApplicationController

  before_filter :require_user, :only => [:index]


  def index
    #überprüfe ob der User an der Kaffeerunde teilnimmt
    if (@current_user.participations.where(coffee_box_id: params[:coffee_box_id]).exists?)
      #Aktuelle coffee_box
      @coffee_box = CoffeeBox.find(params[:coffee_box_id])
      #Monat im Kalender setzen oder verändern
      @date = params[:month] ? Date.parse(params[:month]) : Date.today
      #Keinen Monat anzeigen der vor dem erstellungdatum liegt
      if (@date.month < @coffee_box.created_at.month && @date.year <= @coffee_box.created_at.year)
        @date = @date>>1
      end
      #Consumptions für den Monat erzeugen falls nicht vorhanden
      Consumption.new.create_month(@date, current_user, @coffee_box)
      #Consumptions laden
      @consumptions = current_user.consumptions.where(coffee_box_id: @coffee_box).all
      respond_to do |format|
        format.html
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to coffee_boxes_path, notice: 'You have to participate to the event' }
      end
    end
  end



  def edit
    @coffee_box = CoffeeBox.find(params[:coffee_box_id])
    @consumption = current_user.consumptions.find(params[:id])
    respond_to do |format|
      format.js
      format.html
    end
  end


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
    #Monat der im Kalender ausgewählt ist
    @date = params[:month] ? Date.parse(params[:month]) : Date.today
    #Aktuelle coffee_box
    @coffee_box = CoffeeBox.find(params[:coffee_box_id])
    #abschließen nur möglich wenn auch ein price besteht
    if (@coffee_box.price_of_coffees.where(date: @date.beginning_of_month .. @date.end_of_month).exists?)
      Bill.new.createBillForMonth(@date, current_user, @coffee_box)
      PriceOfCoffee.new.createPriceForNextMonth(@date, @coffee_box,@current_user)
    end
    respond_to do |format|
      format.html { redirect_to coffee_box_consumptions_url(month: @date.strftime("%Y/%m")) }
      format.json { head :no_content }
    end

  end

end
