# encoding: utf-8
class UserSessionsController < ApplicationController
  load_and_authorize_resource

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Login erfolgreich!"
      redirect_back_or_default account_url(@current_user)
    else
      @user_session.errors.full_messages.each do |msg|
        flash[:notice] = msg
      end
      render "new"
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "Logout erfolgreich!"
    redirect_back_or_default new_user_session_url
  end


end