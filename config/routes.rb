Rails.application.routes.draw do
  namespace :admin do
    get 'dashboard', to: 'dashboard#index', as: :dashboard
    resources :users  # Ensure this is here for user management
  end
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  devise_for :users
  root 'posts#index'

  resources :posts do
    resources :comments, only: [:create, :destroy]
    collection do
      get :analytics  # Admin analytics page
    end
  end

  namespace :api do
    namespace :v1 do
      resources :posts do
        resources :comments, only: [:create, :index]
        collection do
          get :analytics
        end
      end

      devise_scope :user do
        post 'sign_in', to: 'sessions#create'
        delete 'sign_out', to: 'sessions#destroy'
      end
    end
  end



end
