require "rails/generators/base"
require "react_particles/generator_helpers"

module ReactParticles
  module Generators
    module Jsbundling
      class ClobberGenerator < Rails::Generators::Base
        include ReactParticles::GeneratorHelpers

        source_root File.expand_path("../jsbundling_templates", __FILE__)

        def copy_react_particles_clobber_rake
          clobber_tt = "clobber.html.erb"
          clobber_path = "#{app_react_particles_rake_tasks_dir}/clobber.rake"
          case self.behavior
          when :invoke
            template(
              clobber_tt,
              clobber_path,
            )
          when :revoke
            if Rails.root.join(clobber_path).exist?
              `rm #{clobber_path}`
              puts indent_str("removed ".red) + "#{clobber_path}"
              `rm -rf #{app_react_particles_rake_tasks_dir}` if (Dir.exists? app_react_particles_rake_tasks_dir) and (Dir.empty? app_react_particles_rake_tasks_dir)
            else
              raise "\n\nreact_particles:jsbundling-rails: Command failed\n\nfile does not exist: \n #{clobber_path}\n\n"
            end
          end
        end

        private

          def app_react_particles_rake_tasks_dir
            return "lib/tasks/react_particles"
          end

      end
    end
  end
end
