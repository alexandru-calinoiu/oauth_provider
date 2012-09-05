OauthProvider::Application.routes.draw do

  get "home/index"

  mount Doorkeeper::Engine => '/oauth'

  devise_for :users

  root :to => "home#index"
end
