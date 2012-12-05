class BillsController < ApplicationController
  # GET /bills
  # GET /bills.json
  def index
    @coffee_box = CoffeeBox.find(params[:coffee_box_id])
    @bills = current_user.bills.where(coffee_box_id:@coffee_box).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bills }
    end
  end

  # GET /bills/1
  # GET /bills/1.json
  def show
    @coffee_box = CoffeeBox.find(params[:coffee_box_id])
    @bill = current_user.bills.where(coffee_box_id:@coffee_box).find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bill }
    end
  end

  # GET /bills/new
  # GET /bills/new.json
  def new
    @coffee_box = CoffeeBox.find(params[:coffee_box_id])
    @bill = current_user.bills.build
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bill }
    end
  end

  # GET /bills/1/edit
  def edit
    @coffee_box = CoffeeBox.find(params[:coffee_box_id])
    @bill = current_user.bills.find(params[:id])
  end

  # POST /bills
  # POST /bills.json
  def create
    @bill = current_user.bills.build(params[:bill])
    @coffee_box = CoffeeBox.find(params[:coffee_box_id])
    @bill.coffee_box = @coffee_box
    @bill.isPaid = true
    respond_to do |format|
      if @bill.save
        format.html { redirect_to coffee_box_bills_path, notice: 'Bill was successfully created.' }
        format.json { render json: @bill, status: :created, location: @bill }
      else
        format.html { render action: "new" }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bills/1
  # PUT /bills/1.json
  def update
    @coffee_box = CoffeeBox.find(params[:coffee_box_id])
    @bill = current_user.bills.find(params[:id])
    @bill.isPaid = true

    respond_to do |format|
      if @bill.update_attributes(params[:bill])
        format.html { redirect_to coffee_box_bills_url, notice: 'Bill was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bills/1
  # DELETE /bills/1.json
  def destroy
    @coffee_box = CoffeeBox.find(params[:coffee_box_id])
    @bill = current_user.bills.find(params[:id])
    @bill.destroy

    respond_to do |format|
      format.html { redirect_to coffee_box_bills_url }
      format.json { head :no_content }
    end
  end
end
