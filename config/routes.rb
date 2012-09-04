OauthProvider::Application.routes.draw do

  mount Doorkeeper::Engine => '/oauth'

  devise_for :users

end
