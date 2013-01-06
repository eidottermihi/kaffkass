# encoding: utf-8
class Ability
  include CanCan::Ability

  # @param [User] user
  def initialize(user)
    # user wird von Cancan automatisch per Aufruf von current_user befüllt
    if user.nil?
      ### Gast
      ## Accountverwaltung
      # Gast kann sich registrieren und anmelden
      can [:new, :create], User
      can [:new, :create], UserSession
      ## Kaffeerunden
      # Gast kann Liste von Kaffeerunden anzeigen
      can :index, CoffeeBox
    elsif user.admin?
      ### Admin
      ## Admin darf ALLES
      can :manage, :all
    else
      ### User
      ## Accountverwaltung
      # User kann sein eigenes Profil komplett bearbeiten
      can [:edit, :update, :destroy, :show], User, :id => user.id
      # User kann sich abmelden
      can [:destroy], UserSession
      ## Kaffeerunden
      # User kann seine eigenen Kaffeerunden komplett bearbeiten (Bedingung: user_id der CoffeeBox ist gleich ID des angemeldeten Users)
      can :manage, CoffeeBox, :user_id => user.id
      # User kann alle Kaffeerunden betrachten und Liste anzeigen
      can [:show, :index, :read], CoffeeBox
      # User kann an Kaffeerunde teilnehmen / sich abmelden
      can [:participate, :unparticipate, :new_participate], CoffeeBox
      # User kann für sich selbst Urlaub verwalten
      can :manage, Holiday, :user_id => user.id
      # User kann Ausgaben eintragen
      # -> manuell im Controller
      # Verwalter einer Kaffeerunde kann Bills als bezahlt markieren
      can :mark_as_paid, Bill if user.administrated_coffee_box_ids.include?(:coffee_box_id)
      # User kann eigene Consumptions bearbeiten
      can [:edit, :update, :index], Consumption, :user_id => user.id
    end
  end

end
