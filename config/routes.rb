Rails.application.routes.draw do
  root "home#index"
  get 'terms', to: 'home#terms'
end
