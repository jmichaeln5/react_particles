require "rails/generators/base"
require "react_particles/generator_helpers"

module ReactParticles
  module Generators
    module Install
      module Assets
        class JavascriptsGenerator < Rails::Generators::Base
          include ReactParticles::GeneratorHelpers

          def generate_react_particles_assets_javascripts_dir
            javascripts_react_particles = "app/assets/javascripts/react_particles"

            case self.behavior
            when :invoke
              say indent_str("\nCreating react_particles javascripts directory...\n")
               `mkdir -p #{javascripts_react_particles}` unless (Dir.exists? javascripts_react_particles)
            when :revoke
              `rm -rf #{javascripts_react_particles}` if (Dir.exists? javascripts_react_particles)
            end
          end

          def generate_javascripts_react_particles_app_js_path
            javascripts_react_particles_app_js_path = "app/assets/javascripts/react_particles/application.js"
            case self.behavior
            when :invoke
              say "\nCreating react_particles javascripts " + "#{javascripts_react_particles_app_js_path}".green + "\n    -React Particles JS bundles here before being delivered to Asset Pipeline\n\n"

              `touch #{javascripts_react_particles_app_js_path}` unless (File.exists? javascripts_react_particles_app_js_path)
            when :revoke
              say indent_str("\n\nRemoving react_particles " + "application.js".green + "\n   -JS for react_particles gets bundled here before getting delivered to asset pipeline \n\n")

              `rm #{javascripts_react_particles_app_js_path}` if (File.exists? javascripts_react_particles_app_js_path)
            end
          end

          def generate_react_particles_sprockets_manifest_path
            sprockets_manifest_path = "app/assets/config/react_particles_manifest.js"

            case self.behavior
            when :invoke
              say "\nCreating react_particles javascripts " + "react_particles_manifest.js".green + "\n    -Entry point for Asset Pipeline\n\n"

              `touch #{sprockets_manifest_path}` unless (File.exists? sprockets_manifest_path)
            when :revoke
              puts indent_str("\n\nremoved ".red) + "#{sprockets_manifest_path}\n\n"
              `rm #{sprockets_manifest_path}` if (File.exists? sprockets_manifest_path)
            end

            if Rails.root.join(sprockets_manifest_path).exist?
              append_to_file sprockets_manifest_path, "//= link_tree ../javascripts/react_particles"
            end
          end

          # def generate_builds
          #   react_particles_builds_dir = "app/assets/react_particles/builds"
          #   react_particles_builds_keep = "app/assets/react_particles/builds/.keep"
          #   case self.behavior
          #   when :invoke
          #     # call_generator("react_particles:install:assets")
          #     unless Rails.root.join(react_particles_builds_dir).exist?
          #       `mkdir #{react_particles_builds_dir}`
          #       `touch #{react_particles_builds_keep}`
          #     end
          #   when :revoke
          #     if Rails.root.join(react_particles_builds_dir).exist?
          #       `rm -rf #{react_particles_builds_dir}`
          #     end
          #   end
          # end

        end
      end
    end
  end
end
