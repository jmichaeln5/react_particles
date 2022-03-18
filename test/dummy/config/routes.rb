Rails.application.routes.draw do
  root 'pages#home'
  get 'pages/about'

  resources :posts
end
