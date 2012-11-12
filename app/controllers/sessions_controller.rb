class SessionsController < ApplicationController
  def new
    render "new"
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      # User-ID in Session schreiben
      session[:user_id] = user.id
      redirect_to home_path, :notice => "Hallo #{user.firstname}!"
    else
      flash.now.alert = "Fehlerhafte E-Mail/Passwort-Kombination."
      render "new"
    end
  end

  def destroy
    # User-ID aus Session löschen
    session[:user_id] = nil
    redirect_to home_path, :notice => "Erfolgreich abgemeldet."
  end
end
