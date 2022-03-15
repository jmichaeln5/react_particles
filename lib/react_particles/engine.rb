module ReactParticles
  class Engine < ::Rails::Engine
    isolate_namespace ReactParticles

    ## Precompiling assets
    ## Article:
      ## https://jakeyesbeck.com/2016/03/20/how-to-build-a-ruby-on-rails-engine/
        ## Find in page:
        ## To enable precompiled assets, a few more lines need to be added in the same engine.rb file:
    initializer("react_particles.assets.precompile") do |app|
      app.config.assets.precompile += [
          # 'application.css', # from article
          # 'application.js' # from article
          'react_particles/application.css', # Personally entered for namespace
          # 'react_particles/application.js' # Personally entered for namespace
        ]
    end

    ## Self mounting with namespace
    ## Article:
      ## https://jakeyesbeck.com/2016/03/20/how-to-build-a-ruby-on-rails-engine/
        ## Find in page:
        ## Alternatively, an Engine can mount itself using the same initializer method in engine.rb:
    initializer('react_particles',
            after: :load_config_initializers) do |app|
      Rails.application.routes.prepend do
        mount ReactParticles::Engine, at: '/react_particles'
      end
    end

  end
end
