require "rails/generators/base"
require "react_particles/generator_helpers"

module ReactParticles
  module Generators
    module Assets
      class StylesheetsGenerator < Rails::Generators::Base
        include ReactParticles::GeneratorHelpers

        STYLESHEETS_PATH = "app/assets/stylesheets/react_particles"

        source_root File.expand_path("../../../../../", __FILE__)

        def generate_stylesheets
          case self.behavior
          when :invoke
            directory STYLESHEETS_PATH, STYLESHEETS_PATH
          when :revoke
            `rm -rf #{STYLESHEETS_PATH}`
            puts indent_str("removed ".red) + "#{STYLESHEETS_PATH.green}/*"
          end
        end

        # def copy_stylesheets
        #   directory STYLESHEETS_PATH, STYLESHEETS_PATH
        # end

      end
    end
  end
end
