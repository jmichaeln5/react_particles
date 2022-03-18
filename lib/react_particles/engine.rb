module ReactParticles
  class Engine < ::Rails::Engine
    isolate_namespace ReactParticles

    ## Precompiling assets
    ## Article:
      ## https://jakeyesbeck.com/2016/03/20/how-to-build-a-ruby-on-rails-engine/
        ## Find comment below in page:
        ## To enable precompiled assets, a few more lines need to be added in the same engine.rb file:
    initializer("react_particles.assets.precompile") do |app|
      app.config.assets.precompile += [
          # 'application.css', # from article
          # 'application.js' # from article
          'react_particles/application.css', # Personally entered
          # 'react_particles/application.js' # Personally entered
        ]
    end
  end
end
