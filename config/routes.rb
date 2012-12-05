Kaffkass::Application.routes.draw do

  #authlogic
  resources :user_sessions

  match 'login' => "user_sessions#new",      :as => :login
  match 'logout' => "user_sessions#destroy", :as => :logout

  resources :users  # give us our some normal resource routes for users
  resource :user, :as => 'account'  # a convenience route

  match 'signup' => 'users#new', :as => :signup

  #email
  match '/activate/:activation_code', :controller => 'activations', :action => 'create' , :as => :activate
  #--------

  #get "test/test"

 # get "home" => "home#home"


  #get "coffeebox/new" => "coffee_box#new"
  #post "coffeebox" => "coffee_box#create"

  resources :coffee_boxes do
    resources :model_of_consumptions
    resources :consumptions
    resources :bills
  end
  match 'coffee_boxes/:id/new_participate' => 'coffee_boxes#new_participate', :as => :new_participate
  match 'coffee_boxes/:id/participate' => 'coffee_boxes#participate', :as => :participate
  match 'coffee_boxes/:id/unparticipate' => 'coffee_boxes#unparticipate', :as => :unparticipate
  match 'my_coffee_boxes' => 'coffee_boxes#my_coffee_boxes', :as => :my_coffee_boxes

  # Root wird auf Home#home geroutet
  root :to => 'home#home'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
