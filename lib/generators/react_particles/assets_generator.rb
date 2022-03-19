# require "administrate/view_generator"
require "rails/generators/base"
require "react_particles/generator_helpers"


module ReactParticles
  module Generators
    class AssetsGenerator < Rails::Generators::Base
      include ReactParticles::GeneratorHelpers

      def generate_assets
        call_generator("react_particles:assets:javascripts")
        call_generator("react_particles:assets:stylesheets")
      end

    end
  end
end
