class ActivationsController < ApplicationController
  before_filter :require_no_user

  def create
    @user = User.find_by_persistence_token(params[:activation_code], 1.week) || (raise Exception)
    raise Exception if @user.active?
    if @user.activate!
      flash[:notice] = "Ihr Account wurde freigeschalten!"
      @user.deliver_welcome!
      redirect_to login_path
    else
      render :action => :new
    end
  end

end