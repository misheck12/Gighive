Rails.application.routes.draw do
  get 'pages/about_us'
  get 'pages/working_with_us'
  # Define root path
  root 'home#index'

  # Home page routes
  get 'home/index', as: 'home'

  # About Us
  get 'about_us', to: 'pages#about_us'

   # contact Us
  get 'contact_us', to: 'pages#contact_us'

  # Working with Us
  get 'working_with_us', to: 'pages#working_with_us'


  # Dashboard routes
  get 'dashboard/show'
  get 'dashboard', to: 'dashboard#show', as: 'dashboard'

  # Devise routes for user authentication with custom controllers for registrations
  devise_for :users, controllers: { registrations: 'users/registrations' }

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

    resources :reviews, only: [:new, :create]
    resources :payments, only: [:new, :create, :show] do
      member do
        patch 'accept', to: 'payments#accept'
        patch 'reject', to: 'payments#reject'
      end
    end
  end

  # Routes for freelancer applications
  resources :freelancer_applications, only: [:new, :create, :index, :show, :edit, :update, :destroy]

  # Independent routes for categories
  resources :categories, only: [] do
    member do
      get :subcategories
    end
  end

  # Independent routes for reviews
  resources :reviews, only: [:show, :edit, :update, :destroy]

  # Any additional routes can be added below
end