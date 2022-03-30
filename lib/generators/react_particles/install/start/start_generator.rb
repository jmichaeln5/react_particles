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

        app_rake_tasks_dir = "lib/tasks"
        app_react_particles_rake_tasks_dir = "#{app_rake_tasks_dir}/react_particles"

        def copy_react_particles_start_rake
          start_tt = "start.html.erb"
          start_path = "#{app_react_particles_rake_tasks_dir}/start.rake"
          `mkdir #{app_react_particles_rake_tasks_dir}` unless (Dir.exists? app_react_particles_rake_tasks_dir)

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

      end
    end
  end
end
