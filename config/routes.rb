Rails.application.routes.draw do
  resources :diaries do
    member do
      delete :purge_image
    end
  end

  get "user_index", to: "catches#user_index"

  resources :catches do
    member do
      delete :purge_image
    end
    resource :like, only: [ :create, :destroy ]
    resources :comments, only: [ :new, :create, :destroy ]
  end

  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
    passwords: "users/passwords",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  root "home#index"

  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
