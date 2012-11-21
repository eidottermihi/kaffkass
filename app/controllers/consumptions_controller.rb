class ConsumptionsController < ApplicationController
  # GET /consumptions
  # GET /consumptions.json
  def index
    @consumptions = current_user.consumptions.where(coffee_box_id:current_user_session.getCurrentCoffeeBox).all
    #Monat im Kalender setzen oder verändern
    @date = params[:month]? Date.parse(params[:month]): Date.today
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @consumptions }
    end
  end

  # GET /consumptions/1
  # GET /consumptions/1.json
  def show
    @consumption = current_user.consumptions.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @consumption }
    end
  end

  # GET /consumptions/new
  # GET /consumptions/new.json
  def new
    @consumption = current_user.consumptions.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @consumption }
    end
  end

  # GET /consumptions/1/edit
  def edit
    @consumption = current_user.consumptions.find(params[:id])
  end

  # POST /consumptions
  # POST /consumptions.json
  def create

    @consumption = current_user.consumptions.build(params[:consumption])
    @consumption.coffee_box=current_user_session.getCurrentCoffeeBox
    respond_to do |format|
      if @consumption.save
        format.html { redirect_to @consumption, notice: 'Consumption was successfully created.' }
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

    respond_to do |format|
      if @consumption.update_attributes(params[:consumption])
        format.html { redirect_to @consumption, notice: 'Consumption was successfully updated.' }
        format.json { head :no_content }
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
    @consumption.destroy

    respond_to do |format|
      format.html { redirect_to consumptions_url }
      format.json { head :no_content }
    end
  end
end
