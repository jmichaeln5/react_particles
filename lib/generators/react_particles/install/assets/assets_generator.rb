require "rails/generators/base"
require "react_particles/generator_helpers"

module ReactParticles
  module Generators
    module Install
      class AssetsGenerator < Rails::Generators::Base
        include ReactParticles::GeneratorHelpers

        def generate_assets
          call_generator("react_particles:install:assets:javascripts")
          call_generator("react_particles:install:assets:stylesheets")
        end

      end
    end
  end
end
