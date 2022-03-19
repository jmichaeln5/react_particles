# require "administrate/view_generator"
require "rails/generators/base"
require "react_particles/generator_helpers"


module ReactParticles
  module Generators
    class AssetsGenerator < Rails::Generators::Base
      include ReactParticles::GeneratorHelpers

      # JAVASCRIPTS_PATH = "app/assets/javascripts/react_particles"
      # STYLESHEETS_PATH = "app/assets/stylesheets/react_particles"
      #
      # def generate_assets
      #   case self.behavior
      #   when :invoke
      #     call_generator("react_particles:assets:javascripts")
      #     call_generator("react_particles:assets:stylesheets")
      #   when :revoke
      #     `rm -rf #{JAVASCRIPTS_PATH}`
      #     puts indent_str("removed ".red) + "#{JAVASCRIPTS_PATH.green}/*"
      #     `rm -rf #{STYLESHEETS_PATH}`
      #     puts indent_str("removed ".red) + "#{STYLESHEETS_PATH.green}/*"
      #   end
      # end

      def copy_assets
        call_generator("react_particles:assets:javascripts")
        call_generator("react_particles:assets:stylesheets")
      end


    end
  end
end
