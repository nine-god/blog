Rails.application.routes.draw do
  resources :articles do 
  	collection do 
  		post :preview
  	end
  end
  
  devise_for :users
  resources :users
  resource :abouts
  
  # get 'home/about' 
  root "home#show"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

