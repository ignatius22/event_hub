Rails.application.routes.draw do
  devise_for :users

  # Root path
  root "events#index"

  # Events
  resources :events do
    member do
      patch :publish
      patch :cancel
    end
    resources :registrations, only: [:create]
  end

  # User-specific routes
  get "my-events", to: "events#my_events", as: :my_events
  get "my-registrations", to: "registrations#my_registrations", as: :my_registrations
  resources :registrations, only: [:destroy]

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
