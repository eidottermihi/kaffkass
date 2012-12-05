# encoding: utf-8
class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities

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
      can [:show, :index], CoffeeBox
      # User kann an Kaffeerunde teilnehmen / sich abmelden
      can [:participate, :unparticipate, :new_participate], CoffeeBox
      # User kann für sich selbst Urlaub verwalten
      can :manage, Holiday, :user_id => user.id
    end
  end
end
