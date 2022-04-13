require "rails/generators/base"
require "react_particles/generator_helpers"

module ReactParticles
  module Generators
    module Jsbundling
      class WatchGenerator < Rails::Generators::Base
        include ReactParticles::GeneratorHelpers

        source_root File.expand_path("../jsbundling_templates", __FILE__)

        class_option :namespace, type: :string, default: "react_application"

        def copy_react_particles_watch_rake
          watch_tt = "watch.html.erb"
          watch_path = "#{app_react_particles_rake_tasks_dir}/watch.rake"

          case self.behavior
          when :invoke
            template(
              watch_tt,
              watch_path,
            )
          when :revoke
            if Rails.root.join(watch_path).exist?
              `rm #{watch_path}`
              puts indent_str("removed ".red) + "#{watch_path}"
              `rm -rf #{app_react_particles_rake_tasks_dir}` if (Dir.exists? app_react_particles_rake_tasks_dir) and (Dir.empty? app_react_particles_rake_tasks_dir)
            else
              print "\n\nreact_particles:jsbundling-rails: Command ignored".yellow
              puts"\n\nfile does not exist: \n #{watch_path}\n\n".red
            end
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
