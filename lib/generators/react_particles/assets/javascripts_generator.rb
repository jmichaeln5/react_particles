require "rails/generators/base"
require "react_particles/generator_helpers"

module ReactParticles
  module Generators
    module Assets
      class JavascriptsGenerator < Rails::Generators::Base
        include ReactParticles::GeneratorHelpers

        ASSETS_JAVASCRIPTS_DIR_PATH = "app/assets/javascripts/react_particles"
        ASSETS_JAVASCRIPTS_APP_JS_FILE_PATH = ASSETS_JAVASCRIPTS_DIR_PATH + "/application.js"
        ASSETS_CONFIG_MANIFEST_FILE_PATH = "app/assets/config/react_particles_manifest.js"

        def generate_react_particles_assets_javascripts_dir
          case self.behavior
          when :invoke
            say indent_str("\nCreating react_particles javascripts directory...\n")
             `mkdir #{ASSETS_JAVASCRIPTS_DIR_PATH}`
          when :revoke
            `rm -rf #{ASSETS_JAVASCRIPTS_DIR_PATH}`
          end
        end

        def generate_react_particles_assets_javascripts_application_js
          case self.behavior
          when :invoke
            say indent_str("\nCreating react_particles javascripts application.js file, entry point for Engine's Asset Pipeline...\n")
            `touch #{ASSETS_JAVASCRIPTS_APP_JS_FILE_PATH}`
          when :revoke
            say indent_str("Removing react_particles javascripts application.js file, entry point for Engine's Asset Pipeline...")
            `rm #{ASSETS_JAVASCRIPTS_APP_JS_FILE_PATH}`
          end
        end

        def generate_react_particles_assets_manifest_js
          case self.behavior
          when :invoke
            say ("Creating react_particles javascripts react_particles_manifest.js file, entry point for Engine's Asset Pipeline")
            `mkdir app/assets/config`
            `touch #{ASSETS_CONFIG_MANIFEST_FILE_PATH}`
          when :revoke
            `rm #{ASSETS_CONFIG_MANIFEST_FILE_PATH}`
            puts indent_str("removed ".red) + "#{ASSETS_CONFIG_MANIFEST_FILE_PATH.green}"
          end
          if (sprockets_manifest_path = Rails.root.join(ASSETS_CONFIG_MANIFEST_FILE_PATH)).exist?
            append_to_file sprockets_manifest_path, %(//= link_tree ../javascripts/react_particles\n)
          end
        end

      end
    end
  end
end
