require "rails/generators/base"
require "react_particles/generator_helpers"

module ReactParticles
  module Generators
    module Install
      module Assets
        class JavascriptsGenerator < Rails::Generators::Base
          include ReactParticles::GeneratorHelpers

          APP_ASSETS_CONFIG_DIR = "app/assets/config"
          APP_ASSETS_JAVASCRIPTS_DIR = "app/assets/javascripts"

          APP_ASSETS_JAVASCRIPTS_REACT_PARTICLES_DIR = "#{APP_ASSETS_JAVASCRIPTS_DIR}/react_particles"
          REACT_PARTICLES_APP_JS_FILE = "#{APP_ASSETS_JAVASCRIPTS_REACT_PARTICLES_DIR}/application.js"
          REACT_PARTICLES_MANIFEST_JS_FILE = "#{APP_ASSETS_CONFIG_DIR}/react_particles_manifest.js"

          def generate_react_particles_assets_javascripts_dir
            case self.behavior
            when :invoke
              say indent_str("\nCreating react_particles javascripts directory...\n")
               `mkdir #{APP_ASSETS_JAVASCRIPTS_REACT_PARTICLES_DIR}` unless (Dir.exists? APP_ASSETS_JAVASCRIPTS_REACT_PARTICLES_DIR)
            when :revoke
              `rm -rf #{APP_ASSETS_JAVASCRIPTS_REACT_PARTICLES_DIR}` if (Dir.exists? APP_ASSETS_JAVASCRIPTS_REACT_PARTICLES_DIR)
            end
          end

          def generate_react_particles_assets_javascripts_application_js
            case self.behavior
            when :invoke
              say indent_str("\n\nCreating react_particles " + "application.js".green + "\n   -JS for react_particles gets bundled here before getting delivered to asset pipeline \n\n")

              `touch #{REACT_PARTICLES_APP_JS_FILE}` unless (File.exists? REACT_PARTICLES_APP_JS_FILE)
            when :revoke
              say indent_str("\n\nremoved ".red + "react_particles/" + "application.js" + "\n   -JS for react_particles gets bundled here before getting delivered to asset pipeline \n\n")
              `rm #{REACT_PARTICLES_APP_JS_FILE}` if (File.exists? REACT_PARTICLES_APP_JS_FILE)
            end
          end

          def generate_react_particles_assets_manifest_js
            case self.behavior
            when :invoke
              say "\nCreating react_particles javascripts " + "react_particles_manifest.js".green + "\n    -Entry point for Engine's Asset Pipeline\n\n"

              `mkdir #{APP_ASSETS_CONFIG_DIR}` unless (Dir.exists? APP_ASSETS_CONFIG_DIR)
              `touch #{REACT_PARTICLES_MANIFEST_JS_FILE}` unless (File.exists? REACT_PARTICLES_MANIFEST_JS_FILE)
            when :revoke
              puts indent_str("\nremoved ".red) + "#{REACT_PARTICLES_MANIFEST_JS_FILE}\n\n"
              `rm #{REACT_PARTICLES_MANIFEST_JS_FILE}` if (File.exists? REACT_PARTICLES_MANIFEST_JS_FILE)
            end
            if Rails.root.join(REACT_PARTICLES_MANIFEST_JS_FILE).exist?
              append_to_file REACT_PARTICLES_MANIFEST_JS_FILE, "//= link_tree ../javascripts/react_particles"
            end
          end

        end
      end
    end
  end
end
