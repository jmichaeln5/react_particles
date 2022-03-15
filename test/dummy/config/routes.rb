Rails.application.routes.draw do
  mount ReactParticles::Engine => "/react_particles" # necessary unless mounting with initializer in engine
end
