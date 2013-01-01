# encoding: utf-8
Kaffkass::Application.routes.draw do
  # Authlogic
  resources :user_sessions

  match 'login' => "user_sessions#new",      :as => :login
  match 'logout' => "user_sessions#destroy", :as => :logout

  resources :users do
    resources :holidays, :only => [:index, :new, :create, :destroy]
  end
  resource :user, :as => 'account'

  match 'signup' => 'users#new', :as => :signup

  # E-Mail Aktivierung
  match '/activate/:activation_code', :controller => 'activations', :action => 'create' , :as => :activate

  # Anwendungsrouten

  resources :coffee_boxes do
    resources :model_of_consumptions
    resources :consumptions, :only => [:index,:update]
    resources :bills, :only => [:index]
    resources :expenses
  end

  # An-Abmeldung zu Kaffeerunden
  match 'coffee_boxes/:id/new_participate' => 'coffee_boxes#new_participate', :as => :new_participate
  match 'coffee_boxes/:id/participate' => 'coffee_boxes#participate', :as => :participate
  match 'coffee_boxes/:id/unparticipate' => 'coffee_boxes#unparticipate', :as => :unparticipate

  # Kaffeerunden, an denen der angemeldete User teilnimmt
  match 'my_coffee_boxes' => 'coffee_boxes#my_coffee_boxes', :as => :my_coffee_boxes

  # Route für Monatsabschluss
  match '/coffee_boxes/:coffee_box_id/close_month' => 'consumptions#close_month', :as => :close_month_coffee_box

  # Route für JSON-Abfrage der Konsum-Statistik für eine Kaffeerunde
  get '/coffee_boxes/:coffee_box_id/consume_chart/:year/:month' => 'statistics#consume_chart', :as => :coffee_box_consume_chart

  # Route für Markieren von Rechnungen als bezahlt
  match '/coffee_boxes/:coffee_box_id/mark_as_paid/:id' => 'bills#mark_as_paid', :as => :mark_as_paid

  # Route zum Monatsabschluss für den letzten Monat, an dem noch keine Bill vorliegt
  match '/coffee_boxes/:coffee_box_id/close_month_for_all' => 'consumptions#close_month_for_all', :as => :close_month_for_all_coffee_box

  # Root wird auf Home#home geroutet
  root :to => 'home#home'
end
