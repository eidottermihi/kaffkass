class ActivationsController < ApplicationController
  before_filter :require_no_user

  def create
    @user = User.find_by_persistence_token(params[:activation_code], 1.week) || (raise Exception)
    raise Exception if @user.active?
    #TODO: mit Fehler umgehen
    if @user.activate!
      flash[:notice] = "Your account has been activated!"
      @user.deliver_welcome!
      redirect_to login_path
    else
      render :action => :new
    end
  end

end