class HolidaysController < ApplicationController

  load_and_authorize_resource :user
  load_and_authorize_resource :holiday, :through => :user

  # GET /users/:user_id/holidays
  # GET /users/:user_id/holidays.json
  def index
    #@holidays = Holiday.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @holidays }
    end
  end

  # GET /holidays/new
  # GET /holidays/new.json
  def new
    #@holiday = Holiday.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @holiday }
    end
  end

  # POST /holidays
  # POST /holidays.json
  def create
    #@holiday = Holiday.new(params[:holiday])


    respond_to do |format|
      if Holiday.new_holiday(@holiday)
        format.html { redirect_to user_holidays_path(@user), notice: 'Urlaub wurde erfolgreich eingetragen.' }
        format.json { render json: @holiday, status: :created }
      else
        format.html { render action: "new" }
        format.json { render json: @holiday.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /holidays/1
  # DELETE /holidays/1.json
  def destroy
    @holiday = Holiday.find(params[:id])
    @holiday.destroy
    respond_to do |format|
      format.html { redirect_to user_holidays_url(@user) }
      format.json { head :no_content }
    end
  end
end
