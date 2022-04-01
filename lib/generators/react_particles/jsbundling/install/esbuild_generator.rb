require "rails/generators/base"
require "react_particles/generator_helpers"

module ReactParticles
  module Generators
    module Jsbundling
      module Install
        class EsbuildGenerator < Rails::Generators::Base
        include ReactParticles::GeneratorHelpers

        end
      end
    end
  end
end
