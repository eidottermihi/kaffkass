# encoding: utf-8

class ExpensesController < ApplicationController

  before_filter :require_user

  load_and_authorize_resource :coffee_box
  load_and_authorize_resource :expense, :through => :coffee_box

  # GET /expenses
  # GET /expenses.json
  def index
    # Zusätzliche Authorisierung, damit nicht leere Ausgabenliste, sondern Exception geworfen wird
    authorize! :index, @coffee_box.expenses.build
    respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @expenses }
    end
  end

  # GET /expenses/1
  # GET /expenses/1.json
  def show
    respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @expense }
    end
  end

  # GET /expenses/new
  # GET /expenses/new.json
  def new
    respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @expense }
    end
  end

  # GET /expenses/1/edit
  def edit
  end

  # POST /expenses
  # POST /expenses.json
  def create
    @expense.user_id = current_user.id
    @expense.flag_abgerechnet = false

    respond_to do |format|
      if @expense.save
        format.html { redirect_to coffee_box_expenses_path(@coffee_box), notice: 'Die Ausgabe wurde gespeichert.' }
        format.json { render json: @expense, status: :created, location: @expense }
      else
        format.html { render action: "new" }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /expenses/1
  # PUT /expenses/1.json
  def update
    respond_to do |format|
      if @expense.flag_abgerechnet?
        format.html { redirect_to coffee_box_expense_path(@coffee_box, @expense), flash.alert => "Ausgabe wurde bereits abgerechnet. Eine nachträgliche Änderung ist nicht erlaubt." }
      elsif @expense.update_attributes(params[:expense])
        format.html { redirect_to coffee_box_expense_path(@coffee_box, @expense), notice: "Änderungen gespeichert." }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expenses/1
  # DELETE /expenses/1.json
  def destroy
    respond_to do |format|
      if @expense.flag_abgerechnet?
        format.html { redirect_to coffee_box_expense_path(@coffee_box, @expense), flash.alert => "Ausgabe wurde bereits abgerechnet. Eine nachträgliche Änderung ist nicht erlaubt." }
      else
        @expense.destroy
        format.html { redirect_to coffee_box_expenses_path(@coffee_box), notice: 'Ausgabe wurde erfolgreich gelöscht.' }
        format.json { head :no_content }
      end
    end
  end
end
