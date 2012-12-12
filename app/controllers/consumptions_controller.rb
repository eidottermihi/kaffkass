class ConsumptionsController < ApplicationController
  # GET /consumptions
  # GET /consumptions.json
  def index
    @coffee_box = CoffeeBox.find(params[:coffee_box_id])
    #Monat im Kalender setzen oder verändern
    @date = params[:month]? Date.parse(params[:month]): Date.today
    #Keinen Monat anzeigen der vor dem erstellungdatum liegt
    if(@date.month < @coffee_box.created_at.month && @date.year <= @coffee_box.created_at.year)
      @date = @date>>1
    end
    #Consumptions für den Monat erzeugen
    Consumption.new.createMonth(@date,current_user,@coffee_box)
    #TODO: Es muss noch ein neuer Preis für Kaffe-Box und Monat erstellt werden da sonst die Abrechnung nicht getätigt werden kann
    #bzw. kann auch auf der View der Link gesperrt werden .. dieser muss eh noch gesperrt werden wenn der Monat abgerechnet ist ...
    @consumption = Consumption.new
    @consumptions = current_user.consumptions.where(coffee_box_id:@coffee_box).all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @consumptions }
      format.js
    end
  end

  # GET /consumptions/1
  # GET /consumptions/1.json
  def show
    @consumption = current_user.consumptions.find(params[:id])
    @coffee_box = CoffeeBox.find(params[:coffee_box_id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @consumption }
    end
  end

  # GET /consumptions/new
  # GET /consumptions/new.json
  def new
    @consumption = current_user.consumptions.build
    @coffee_box = CoffeeBox.find(params[:coffee_box_id])
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @consumption }
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

  # POST /consumptions
  # POST /consumptions.json
  def create

    @consumption = current_user.consumptions.build(params[:consumption])
    @coffee_box = CoffeeBox.find(params[:coffee_box_id])
    @consumption.coffee_box=@coffee_box
    respond_to do |format|
      if @consumption.save
        format.html { redirect_to coffee_box_consumptions_path, notice: 'Consumption was successfully created.' }
        format.json { render json: @consumption, status: :created, location: @consumption }
      else
        format.html { render action: "new" }
        format.json { render json: @consumption.errors, status: :unprocessable_entity }
      end
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

  # DELETE /consumptions/1
  # DELETE /consumptions/1.json
  def destroy
    @consumption = current_user.consumptions.find(params[:id])
    @coffee_box = CoffeeBox.find(params[:coffee_box_id])
    @consumption.destroy

    respond_to do |format|
      format.html { redirect_to coffee_box_consumptions_url }
      format.json { head :no_content }
    end
  end

  def closeMonth
    @date = params[:month]? Date.parse(params[:month]): Date.today
    @coffee_box = CoffeeBox.find(params[:coffee_box_id])
    Bill.new.createBillsForMonth(@date, current_user, @coffee_box)
    #TODO: bill für user und coffebox erstellen --> alle consumptions für den Monat auf disabled

    respond_to do |format|
      format.html { redirect_to coffee_box_consumptions_url(month:@date.strftime("%Y/%m")) }
      format.json { head :no_content }
    end
  end
end
