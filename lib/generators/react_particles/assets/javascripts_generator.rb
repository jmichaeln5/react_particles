require "rails/generators/base"
require "react_particles/generator_helpers"

module ReactParticles
  module Generators
    module Assets
      class JavascriptsGenerator < Rails::Generators::Base
        include ReactParticles::GeneratorHelpers

        JAVASCRIPTS_PATH = "app/assets/javascripts/react_particles"

        source_root File.expand_path("../../../../../", __FILE__)

        def generate_javascripts
         case self.behavior
         when :invoke
           directory JAVASCRIPTS_PATH, JAVASCRIPTS_PATH
         when :revoke
           `rm -rf #{JAVASCRIPTS_PATH}`
           puts indent_str("removed ".red) + "#{JAVASCRIPTS_PATH.green}/*"
         end
        end

        # def copy_javascripts
        #   directory JAVASCRIPTS_PATH, JAVASCRIPTS_PATH
        # end

      end
    end
  end
end
