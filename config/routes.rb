Rails.application.routes.draw do
  resources :articles
  devise_for :users
  get 'home/about'
  root "home#show"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

