require "rails/generators/base"
require "react_particles/generator_helpers"

module ReactParticles
  module Generators
    module Install
      module Assets
        class StylesheetsGenerator < Rails::Generators::Base
          include ReactParticles::GeneratorHelpers

          source_root File.expand_path("../../../../../../", __FILE__)

          REACT_PARTICLES_STYLESHEETS_DIR = "app/assets/stylesheets/react_particles"

          def generate_stylesheets
            case self.behavior
            when :invoke
              directory REACT_PARTICLES_STYLESHEETS_DIR, REACT_PARTICLES_STYLESHEETS_DIR unless (Dir.exists? REACT_PARTICLES_STYLESHEETS_DIR)
            when :revoke
              `rm -rf #{REACT_PARTICLES_STYLESHEETS_DIR}` if (Dir.exists? REACT_PARTICLES_STYLESHEETS_DIR)
              puts indent_str("removed ".red) + "#{REACT_PARTICLES_STYLESHEETS_DIR}/*"
            end
          end

        end
      end
    end
  end
end
