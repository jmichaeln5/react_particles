require "rails/generators/base"
require "react_particles/generator_helpers"
require "react_particles/namespace"

module ReactParticles
  module Generators
    module Install
      class StartGenerator < Rails::Generators::Base
        include ReactParticles::GeneratorHelpers

        source_root File.expand_path("../start_templates", __FILE__)

        class_option :namespace, type: :string, default: "react_application"

        def copy_react_particles_start_rake
          start_tt = "start.html.erb"
          start_path = "#{app_react_particles_rake_tasks_dir}/start.rake"

          case self.behavior
          when :invoke
            template(
              start_tt,
              start_path,
            )
          when :revoke
            `rm -rf #{app_react_particles_rake_tasks_dir}` if (Dir.exists? app_react_particles_rake_tasks_dir)
            puts indent_str("removed ".red) + "#{start_path}"
          end
        end

        private

          def namespace
            options[:namespace]
          end

          def app_react_particles_rake_tasks_dir
            return "lib/tasks/react_particles"
          end

      end
    end
  end
end
