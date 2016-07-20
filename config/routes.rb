require 'sidekiq/web'
require 'admin_constraint'

Rails.application.routes.draw do

  if Rails.env.development?
    mount Sidekiq::Web => "/sidekiq"
  else
    mount Sidekiq::Web => "/sidekiq", constraints: AdminConstraint.new
  end
  
  root 'home#index'
  
  get 'home/index'

  get 'password_resets/new'

  get 'password_resets/edit'


  get 'signup' => 'users/users#new'
  get 'login' => 'users/sessions#new'
  post 'login' => 'users/sessions#create'
  delete 'logout' => 'users/sessions#destroy'
  
  namespace :admin do
    resources :dashboard, only: [:index]
      
    namespace :users do
      
      resources :users, only: [:index, :destroy] do
        collection do
          get 'list/:list' =>'users#index', as: :list
          get 'search', as: :search
        end
      end
      resources :filters
    end
  end
  
  namespace :users do
    
    get 'sessions/new'
    
    # /!\ order has importance here 
    # if we want edit  not to be considered as a username
    get 'user/edit' => 'users#edit', as: :edit
    
    get 'user/:username' => 'users#show', as: :show
    
    patch 'user' => 'users#update', as: :update
  
    delete 'user' => 'users#destroy', as: :destroy
    
    resources :users, except: [:show, :edit, :update, :destroy] do
    end

    resources :account_activations, only: [:edit]
    
    resources :password_resets, only: [:new, :create, :edit, :update]
  
    resources :dashboard, only: [:index]
    
    resources :preferences, only: [:index]
    
    resources :notifications, only: [:index] do
      collection do
        get 'unread_all'
      end
    end
  end # namespace users

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".



  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
