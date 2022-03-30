require "rails/generators/base"
require "react_particles/generator_helpers"
require "react_particles/namespace"

module ReactParticles
  module Generators
    module Jsbundling
      class BuildGenerator < Rails::Generators::Base
        include ReactParticles::GeneratorHelpers

      end
    end
  end
end
