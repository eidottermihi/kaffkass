# encoding: utf-8
class UsersController < ApplicationController
  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to home_path, :notice => "Registrierung erfolgreich. Sie können sich nun anmelden."
    else
      render "new"
    end
  end

  def new
    @user = User.new
  end
end
