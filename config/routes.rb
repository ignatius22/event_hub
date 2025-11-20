Rails.application.routes.draw do
  devise_for :users

  # Root path
  root "events#index"

  # Events
  resources :events do
    member do
      patch :publish
      patch :cancel
      get :calendar
    end
    resources :registrations, only: [:create]
    resources :comments, only: [:create, :destroy]
    resources :reviews, only: [:create, :destroy]
    resources :check_ins, only: [:new, :create]
  end

  # User-specific routes
  get "my-events", to: "events#my_events", as: :my_events
  get "my-registrations", to: "registrations#my_registrations", as: :my_registrations
  get "my-bookmarks", to: "bookmarks#index", as: :my_bookmarks
  get "recommendations", to: "recommendations#index", as: :recommendations
  resources :registrations, only: [:destroy]
  resources :bookmarks, only: [:create, :destroy]

  # Tags
  resources :tags, only: [:index, :show]

  # Admin namespace
  namespace :admin do
    get "dashboard", to: "dashboard#index", as: :dashboard
    resources :events, only: [:index, :update]
    resources :users, only: [:index, :show]
  end

  # API namespace
  namespace :api do
    namespace :v1 do
      resources :events, only: [:index, :show] do
        member do
          post :rsvp
        end
      end
      post "auth/login", to: "auth#login"
    end
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
