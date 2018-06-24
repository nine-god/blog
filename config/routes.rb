require 'sidekiq/web'
Rails.application.routes.draw do



  resource :abouts

  resources :articles do
    resources :comments
  	collection do
  		post :preview
  	end
  end

  resource :photos

  get 'users/sign_in' , to: 'auth/sessions#new' , as: 'new_user_session'
  # post 'users/sign_in' , to: 'auth/sessions#new' , as: 'new_user_session'
  get 'users/sign_up' , to: 'auth/users#new'
  delete 'users/sign_out', to: 'auth/sessions#destroy', as: 'destroy_user_session'
  scope module: 'auth' do
    resources :users do
      collection do
        get  :confirmation
        get  :new_password
        post :reset_password_mail
        get  :edit_password
        put :reset_password
      end
    end
    resource :session
    resources :roles
  end

  namespace :auth do

    get 'omniauth_callbacks/qq' , to: 'omniauth_callbacks#qq'
    get 'omniaut_authorize/redirect' , to: 'omniauth_callbacks#authoriz' ,as: 'omniauth_authorize'


  end

  get 'notifications/index'
  delete 'notifications/clean'

  mount Sidekiq::Web => '/sidekiq',  constraints: -> (request){
    user = User.find_by_id(request.session[:user_id])
    user && user.admin?
  }

  # get 'auth/omniauth_callbacks/qq' , to: 'auth/omniauth_callbacks#qq'
  # get 'auth/omniaut_authorize/redirect' , to: 'auth/omniauth_callbacks#authoriz' ,as: 'omniauth_authorize'



  get 'photo/*name', to: 'photos#show', format: true,constraints: { format: 'png' }
  # get 'home/about'
  root "home#show"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

