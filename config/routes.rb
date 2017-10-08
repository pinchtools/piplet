require 'sidekiq/web'
require 'sidekiq-scheduler/web'
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

      resources :users, param: :username do
        collection do
          get 'list/:list' =>'users#index', as: :list
          get 'search', as: :search
        end

        member do
          post 'revert_removal', as: :revert_removal
          post 'block', as: :block
          post 'revert_block', as: :revert_block
          post 'suspect', as: :suspect
          post 'revert_suspect', as: :revert_suspect
        end
      end

      resources :filters

      scope(':username') do
        resources :dashboard, only: [:index]

        resources :preferences, only: [:index]

        resources :notifications, only: [:index]

        resources :permissions, only: [:index]

        resources :logs, only: [:index, :show]
      end
    end

    scope module: 'sites' do

      resources :sites, param: :site_uid

      scope('sites/:site_uid') do
        patch 'edit', to: 'sites#update', as: :site_update

        resources :api_keys
      end

    end

    # resources :settings, only: [:index]
    get 'settings/index', as: :settings
    post 'settings/update', as: :update_settings

  end

  namespace :users do

    get 'sessions/new'

    get 'user/edit' => 'users#edit', as: :edit

    patch 'user' => 'users#update', as: :update

    delete 'user' => 'users#destroy', as: :destroy

    resources :users, except: [:show, :edit, :update, :destroy] do
      collection do
        get 'check_username', as: :check_username
      end
    end

    # /!\ order has importance here
    # if we want default actions  not to be considered as a username
    # please let this line after other 'users' routes
    get 'user/:username' => 'users#show', as: :show


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

  #omniauth
  match '/auth/:provider/callback', to: 'users/omniauth#callback', via: :all
  match '/auth/failure', to: 'users/omniauth#failure', via: :all
  match '/auth/:token', to: 'users/omniauth#complete_profile', via: :get, as: :auth_complete_profile
  match '/auth/:token', to: 'users/omniauth#finalize', via: :post, as: :auth_finalize

  namespace :api do
    namespace :v1 do
      resources :users, only: [:create] do
        collection do
          put :update
          get '/show' => 'users#show'
        end
      end
      resources :tokens, only: [:create] do
        collection do
          put :update
        end
      end
    end #v1
  end # namespace api

  namespace :client do
    get '/' =>'home#index', as: :home
  end
end
