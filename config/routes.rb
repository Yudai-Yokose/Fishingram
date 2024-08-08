Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords',
  }
  get 'user_posts', to: 'posts#user_posts', as: :user_posts
  resources :posts do
    member do
      delete :purge_image
    end
  end
  root "home#index"
  get 'terms', to: 'home#terms'
end
