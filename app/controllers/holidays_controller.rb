# encoding: utf-8
class HolidaysController < ApplicationController

  load_and_authorize_resource :user
  load_and_authorize_resource :holiday, :through => :user

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @holidays }
    end
  end

  def new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @holiday }
    end
  end

  def create
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

  def destroy
    @holiday = Holiday.find(params[:id])
    respond_to do |format|
      if @holiday.delete_holiday
        format.html { redirect_to user_holidays_url(@user), notice: 'Urlaub wurde erfolgreich gelöscht.' }
        format.json { head :no_content }
      else
        format.html { redirect_to user_holidays_path(@user), notice: 'Urlaub kann nicht gelöscht werden, Monat bereits abgeschlossen.'}
        format.json { render json: @holiday.errors, status: :unprocessable_entity}
      end
    end
  end
end
