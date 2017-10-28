Rails.application.routes.draw do
  get 'articles/index'

  get 'home/show'
  get "home/about"

  get 'welcome/index'
  root "home#show"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
