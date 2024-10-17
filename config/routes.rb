Rails.application.routes.draw do
  get "pages/contact"
  resources :diaries do
    member do
      delete :purge_image
    end
  end

  get "index_user", to: "catches#index_user"

  resources :catches do
    member do
      delete :purge_image
    end
    resource :like, only: [ :create, :destroy ]
    resources :comments, only: [ :new, :create, :index, :destroy, :edit, :update ]
  end

  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
    passwords: "users/passwords",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  root "home#index"

  namespace :admin do
    get "dashboard", to: "dashboard#index"
    resources :users
    resources :catches
    resources :diaries
  end

  get "terms", to: "home#terms"
  get "privacy_policy", to: "home#privacy_policy"
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
