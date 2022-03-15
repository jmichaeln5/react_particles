ReactParticles::Engine.routes.draw do
  root to: 'components#index'
  get 'components/root'
end
