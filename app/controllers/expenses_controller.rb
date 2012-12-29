# encoding: utf-8

class ExpensesController < ApplicationController

  before_filter :require_user

  # GET /expenses
  # GET /expenses.json
  def index
    @expenses = Expense.where(coffee_box_id: params[:coffee_box_id])
    @coffee_box = CoffeeBox.find(params[:coffee_box_id])
    respond_to do |format|
      if current_user.participates?(@coffee_box)
        format.html # index.html.erb
        format.json { render json: @expenses }
      else
        format.html { redirect_to coffee_box_path(@coffee_box), :notice => "Zugriff verweigert." }
        format.json { render json: 'Access denied' }
      end
    end


  end

  # GET /expenses/1
  # GET /expenses/1.json
  def show
    @expense = Expense.find(params[:id])
    @coffee_box = CoffeeBox.find(params[:coffee_box_id])

    respond_to do |format|
      if current_user.participates?(@coffee_box)
        format.html # show.html.erb
        format.json { render json: @expense }
      else
        format.html { redirect_to coffee_box_path(@coffee_box), :notice => "Zugriff verweigert." }
        format.json { render json: 'Access denied' }
      end
    end
  end

  # GET /expenses/new
  # GET /expenses/new.json
  def new
    @coffee_box = CoffeeBox.find(params[:coffee_box_id])
    @expense = @coffee_box.expenses.build
    respond_to do |format|
      if current_user.participates?(@coffee_box)
        format.html # new.html.erb
        format.json { render json: @expense }
      else
        format.html { redirect_to coffee_box_path(@coffee_box), :notice => "Zugriff verweigert." }
        format.json { render json: 'Access denied' }
      end
    end
  end

  # GET /expenses/1/edit
  def edit
    @expense = Expense.find(params[:id])
    @coffee_box = CoffeeBox.find(params[:coffee_box_id])
    if not current_user.participates?(@coffee_box) or not current_user.expenses.all.include?(@expense)
      redirect_to coffee_box_expenses_path(@coffee_box), :notice => "Zugriff verweigert."
    end
  end

  # POST /expenses
  # POST /expenses.json
  def create
    @coffee_box = CoffeeBox.find(params[:coffee_box_id])
    @expense = @coffee_box.expenses.build(params[:expense])
    @expense.user_id = current_user.id


    respond_to do |format|
      if not current_user.participates?(@coffee_box)
        format.html { redirect_to coffee_box_path(@coffee_box), notice: "Zugriff verweigert." }
        format.json { render json: 'Access denied' }
      elsif @expense.save
        format.html { redirect_to coffee_box_expense_path(@coffee_box, @expense), notice: 'Die Ausgabe wurde gespeichert.' }
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
    @expense = Expense.find(params[:id])
    @coffee_box = CoffeeBox.find(params[:coffee_box_id])


    respond_to do |format|
      if not current_user.participates?(@coffee_box) or not current_user.expenses.all.include?(@expense)
        format.html { redirect_to coffee_box_path(@coffee_box), notice: "Zugriff verweigert." }
        format.json { render json: 'Access denied' }
      elsif @expense.flag_abgerechnet?
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
    @expense = Expense.find(params[:id])
    @coffee_box = CoffeeBox.find(params[:coffee_box_id])

    respond_to do |format|
      if not current_user.participates?(@coffee_box) or not current_user.expenses.all.include?(@expense)
        format.html { redirect_to coffee_box_path(@coffee_box), notice: "Zugriff verweigert." }
        format.json { render json: 'Access denied' }
      else
        @expense.destroy
        format.html { redirect_to coffee_box_expenses_path(@coffee_box), notice: 'Ausgabe wurde erfolgreich gelöscht.' }
        format.json { head :no_content }
      end
    end
  end
end
