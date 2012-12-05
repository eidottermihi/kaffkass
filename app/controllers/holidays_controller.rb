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

  # GET /holidays/1
  # GET /holidays/1.json
  def show
    #@holiday = Holiday.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @holiday }
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

  # GET /holidays/1/edit
  def edit
    @holiday = Holiday.find(params[:id])
  end

  # POST /holidays
  # POST /holidays.json
  def create
    #@holiday = Holiday.new(params[:holiday])


    respond_to do |format|
      if Holiday.new_holiday(@holiday)
        format.html { redirect_to user_holiday_path(@user, @holiday), notice: 'Holiday was successfully created.' }
        format.json { render json: @holiday, status: :created, location: user_holiday_url(@user, @holiday) }
      else
        format.html { render action: "new" }
        format.json { render json: @holiday.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /holidays/1
  # PUT /holidays/1.json
  def update
    #@holiday = Holiday.find(params[:id])

    respond_to do |format|
      if @holiday.update_attributes(params[:holiday])
        format.html { redirect_to user_holiday_path(@user, @holiday), notice: 'Holiday was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
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
