ReactParticles::Engine.routes.draw do
  get 'components/index'
end

#### Routing Article
# https://devblast.com/b/rails-5-routes-scope-vs-namespace
# scope module: 'admin' do
#   resources :users
# end

# Prefix Verb   URI Pattern          Controller#Action
#  users GET    /users(.:format)     admin/users#index
#        POST   /users(.:format)     admin/users#create
#   user GET    /users/:id(.:format) admin/users#show
#        PATCH  /users/:id(.:format) admin/users#update
#        PUT    /users/:id(.:format) admin/users#update
#        DELETE /users/:id(.:format) admin/users#destroy
