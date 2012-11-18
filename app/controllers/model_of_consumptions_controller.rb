class ModelOfConsumptionsController < ApplicationController
  before_filter :require_user

  def create
    @coffee_box = CoffeeBox.find(params[:coffee_box_id])
    if(params[:no_consumption_model])
      redirect_to coffee_boxes_path, notice: "Anmeldung ohne Konsummodell erfolgreich abgeschlossen."
    else
      @model_of_consumption = ModelOfConsumption.new(params[:model_of_consumption])
      @model_of_consumption.user= current_user
      @model_of_consumption.coffee_box = CoffeeBox.find(params[:coffee_box_id])
      if @model_of_consumption.save
        redirect_to coffee_boxes_path, notice: "Anmeldung erfolgreich abgeschlossen."
      else
        render "coffee_boxes/new_participate"
      end
    end

  end
end
