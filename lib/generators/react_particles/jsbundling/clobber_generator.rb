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
            `rm -rf #{app_react_particles_rake_tasks_dir}` if (Dir.exists? app_react_particles_rake_tasks_dir)
            puts indent_str("removed ".red) + "#{clobber_path}"
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
