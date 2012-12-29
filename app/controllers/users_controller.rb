class UsersController < ApplicationController

  # Authorisierung über Cancan
  load_and_authorize_resource

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])

    # Saving without session maintenance to skip
    # auto-login which can't happen here because
    # the User has not yet been activated
    if @user.save_without_session_maintenance
      @user.deliver_activation_instructions!
      flash[:notice] = "Ihr Account wurde erstellt. Bitte pruefen Sie ihren E-Mail-Eingang!"
      redirect_to root_url
    else
      flash[:notice] = "Beim Erstellen ihres Accounts ist ein Problem aufgetreten."
          render :action => :new
    end

  end

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account aktualisiert!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end



end
