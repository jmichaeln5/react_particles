require "rails/generators/base"
require "react_particles/generator_helpers"

module ReactParticles
  module Generators
    module Install
      class AssetsGenerator < Rails::Generators::Base
        include ReactParticles::GeneratorHelpers

        def generate_assets
          call_generator("react_particles:install:assets:javascripts")
          call_generator("react_particles:install:assets:stylesheets")

            if (host_app_assets_path = Rails.root.join("app/assets")).exist?

              react_particles_assets = "#{host_app_assets_path}/react_particles"
              `mkdir #{react_particles_assets}`

              react_particles_builds_dir = "#{react_particles_assets}/builds"
              `mkdir #{react_particles_builds_dir}`

              bg_rollup_output_file = "#{react_particles_builds_dir}/application.js"
              `touch #{bg_rollup_output_file}`

              react_particles_builds_keep = "#{react_particles_builds_dir}/.keep"
              `touch #{react_particles_builds_keep}`

            end


        end

      end
    end
  end
end
