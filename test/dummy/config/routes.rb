Rails.application.routes.draw do
  scope module: 'react_application' do 
     get 'components/index'
  end

  root 'pages#home'
  get 'pages/about'

  resources :posts
end
