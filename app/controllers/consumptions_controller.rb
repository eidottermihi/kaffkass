# encoding: utf-8
class ConsumptionsController < ApplicationController

  before_filter :require_user, :only => [:index]


  def index
    #überprüfe ob der User an der Kaffeerunde teilnimmt
    if @current_user.participations.where(coffee_box_id: params[:coffee_box_id]).exists?
      #Aktuelle coffee_box
      @coffee_box = CoffeeBox.find(params[:coffee_box_id])
      #Monat im Kalender setzen oder verändern
      @date = params[:month] ? Date.parse(params[:month]) : Date.today
      #Keinen Monat anzeigen der vor dem erstellungdatum liegt
      if @date.month < @coffee_box.created_at.month && @date.year <= @coffee_box.created_at.year
        @date = Date.today
      end
      #Consumptions für den Monat erzeugen falls nicht vorhanden
      Consumption.create_month(@date, current_user, @coffee_box)
      #Consumptions laden
      @consumptions = current_user.consumptions.where(coffee_box_id: @coffee_box, day: @date.beginning_of_month..@date.end_of_month).all
      respond_to do |format|
        format.html
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to coffee_boxes_path, notice: 'Zugriff verweigert. Sie müssen an der Kaffeerunde teilnehmen.' }
      end
    end
  end


  def edit
    @coffee_box = CoffeeBox.find(params[:coffee_box_id])
    @consumption = current_user.consumptions.find(params[:id])
    authorize! :edit, @consumption, :message => 'Zugriff auf fremden Konsumeintrag verweigert.'
    respond_to do |format|
      format.js
      format.html
    end
  end


  def update
    @consumption = current_user.consumptions.find(params[:id])
    @coffee_box = CoffeeBox.find(params[:coffee_box_id])
    authorize! :edit, @consumption, :message => 'Zugriff auf fremden Konsumeintrag verweigert.'
    @consumption.flag_touched = true
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


  def close_month
    # Monat der im Kalender ausgewählt ist
    @date = params[:month] ? Date.parse(params[:month]) : Date.today
    # Aktuelle coffee_box
    @coffee_box = CoffeeBox.find(params[:coffee_box_id])
    # Abschließen nur möglich wenn auch ein price besteht
    if @coffee_box.price_of_coffees.where(date: @date.beginning_of_month .. @date.end_of_month).exists?
      Bill.new.create_bill_for_month(@date, current_user, @coffee_box)
      PriceOfCoffee.new.create_price_for_next_month(@date, @coffee_box)
    end
    respond_to do |format|
      format.html { redirect_to coffee_box_consumptions_url(month: @date.strftime("%Y/%m")), notice: 'Monat erfolgreich abgeschlossen.' }
      format.json { head :no_content }
    end
  end

end
