Rails.application.routes.draw do
  devise_for :users
  resources :articles, only: [:new, :create, :show, :index]

  root controller: :articles, action: :index

  namespace :api, defaults: { format: :json } do
    mount_devise_token_auth_for 'User', at: 'auth'
  end
end
