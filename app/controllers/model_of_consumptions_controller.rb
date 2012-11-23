# encoding: utf-8
class ModelOfConsumptionsController < ApplicationController
  before_filter :require_user

  def new
    @coffee_box = CoffeeBox.find(params[:coffee_box_id])
    @model_of_consumption = current_user.model_of_consumptions.build
  end

  def create
    @coffee_box = CoffeeBox.find(params[:coffee_box_id])
    if (params[:no_consumption_model])
      redirect_to coffee_boxes_path, notice: "Kein Konsummodell hinterlegt."
    else
      @model_of_consumption = current_user.model_of_consumptions.build(params[:model_of_consumption])
      @model_of_consumption.coffee_box = CoffeeBox.find(params[:coffee_box_id])
      if @model_of_consumption.save
        redirect_to coffee_boxes_path, notice: "Konsummodell erfolgreich hinterlegt."
      else
        render "new"
      end
    end
  end

  def destroy
    @coffee_box = CoffeeBox.find(params[:coffee_box_id])
    @model_of_consumption = ModelOfConsumption.find(params[:id])
    @model_of_consumption.destroy
    redirect_to coffee_box_path(@coffee_box), notice: "Konsummodell gelöscht."
  end

  def show
    @coffee_box = CoffeeBox.find(params[:coffee_box_id])
    @model_of_consumption = ModelOfConsumption.find(params[:id])
  end

  def edit
    @model_of_consumption = ModelOfConsumption.find(params[:id])
    @coffee_box = CoffeeBox.find(params[:coffee_box_id])
  end

  def update
    @model_of_consumption = ModelOfConsumption.find(params[:id])
    if @model_of_consumption.update_attributes(params[:model_of_consumption])
      redirect_to coffee_boxes_path, notice: "Update des Konsummodells erfolgreich."
    else
      render "edit"
    end
  end

end
