require "rails/generators/base"
require "react_particles/generator_helpers"
require "react_particles/namespace"

module ReactParticles
  module Generators
    module Jsbundling
      class ReactParticlesStartGenerator < Rails::Generators::Base
        include ReactParticles::GeneratorHelpers

        source_root File.expand_path("../jsbundling_templates", __FILE__)

        class_option :namespace, type: :string, default: "react_application"

        APP_RAKE_TASKS_DIR = "lib/tasks"
        APP_REACT_PARTICLES_RAKE_TASKS_DIR = "#{APP_RAKE_TASKS_DIR}/react_particles"

        def copy_react_particles_start_rake
          react_particles_start_tt = "react_particles_start.html.erb"

          case self.behavior
          when :invoke
            template(
              react_particles_start_tt,
              react_particles_start_path,
            )
          when :revoke
            `rm -rf #{APP_REACT_PARTICLES_RAKE_TASKS_DIR}` if (Dir.exists? APP_REACT_PARTICLES_RAKE_TASKS_DIR)
            puts indent_str("removed ".red) + "#{react_particles_start_path}"
          end
        end

        private

        def namespace
          options[:namespace]
        end

        def react_particles_start_path
          return react_particles_start_path = "#{APP_REACT_PARTICLES_RAKE_TASKS_DIR}/react_particles_start.rake"
        end

      end
    end
  end
end
