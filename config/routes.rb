Rails.application.routes.draw do
  # Define root path
  root 'dashboard#show'

  # Dashboard routes
  get 'dashboard/show'
  get 'dashboard', to: 'dashboard#show', as: 'dashboard'

  # Devise routes for user authentication with custom controllers
  devise_for :users, controllers: { 
    registrations: 'users/registrations',
    sessions: 'users/sessions' # Include custom sessions controller
  }

  # Custom routes within Devise for handling special user registration flows
  devise_scope :user do
    get 'users/new_freelancer', to: 'users/registrations#new_freelancer', as: :new_freelancer_registration
    post 'users/create_freelancer', to: 'users/registrations#create_freelancer', as: :create_freelancer_registration
    delete 'users/:id', to: 'users/registrations#destroy', as: :admin_destroy_user
    get '/users/sign_out', to: 'devise/sessions#destroy'
  end

  # Routes for tasks
  resources :tasks do
    member do
      post 'accept'
      post 'complete'
      post 'changes'
      post 'submit_changes'
    end

    # Nested routes for reviews and payments within tasks
    resources :reviews, only: [:new, :create]
    resources :payments, only: [:new, :create, :show] do
      member do
        patch 'accept', to: 'payments#accept'
        patch 'reject', to: 'payments#reject'
      end
    end
  end

  # Independent routes for reviews
  resources :reviews, only: [:show, :edit, :update, :destroy]

  # Mount Sidekiq web interface
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
