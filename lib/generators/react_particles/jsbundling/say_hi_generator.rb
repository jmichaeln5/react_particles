require "rails/generators/base"
require "react_particles/generator_helpers"
require "react_particles/namespace"

module ReactParticles
  module Generators
    module Jsbundling
      class SayHiGenerator < Rails::Generators::Base
        include ReactParticles::GeneratorHelpers

        source_root File.expand_path("../jsbundling_templates", __FILE__)

        APP_RAKE_TASKS_DIR = "lib/tasks"
        APP_REACT_PARTICLES_RAKE_TASKS_DIR = "#{APP_RAKE_TASKS_DIR}/react_particles"

        def copy_say_hi_rake
          say_hi_rake_tt = "say_hi.rake.tt"

          case self.behavior
          when :invoke
            template(
              say_hi_rake_tt,
              say_hi_tt_destination,
            )
          when :revoke
            `rm -rf #{APP_REACT_PARTICLES_RAKE_TASKS_DIR}` if (Dir.exists? APP_REACT_PARTICLES_RAKE_TASKS_DIR)
            puts indent_str("removed ".red) + "#{say_hi_tt_destination}/*"
          end
        end

        private

        def say_hi_tt_destination
          return say_hi_tt_destination = "#{APP_REACT_PARTICLES_RAKE_TASKS_DIR}/say_hi.rake"
        end

      end
    end
  end
end
