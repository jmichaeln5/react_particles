require "rails/generators/base"
require "react_particles/generator_helpers"
require 'json'

module ReactParticles
  module Generators
    module Jsbundling
      module Install
        class RollupGenerator < Rails::Generators::Base
          include ReactParticles::GeneratorHelpers

          source_root File.expand_path("../rollup_templates", __FILE__)

          class_option :namespace, type: :string, default: "react_application"
          class_option :js_bundler, type: :string, default: "rollup"

          def ensure_react_particles_js
            call_generator("react_particles:install:assets")
          end

          def ensure_javascript_dir_path
            unless Rails.root.join(javascript_dir_path).exist?
              `mkdir #{javascript_dir_path}`
              `touch #{javascript_dir_path}/application.js`
            end
          end

          def ensure_package_json
            if self.behavior == :invoke
              rollup_package_json = "#{javascript_dir_path}/package.json"
              `touch #{rollup_package_json}`

              rollup_config_json ="
              \n{" +
              "\n  \"name\": \"#{namespace}\", " +
              "\n  \"private\": \"true\"" +
              "\n}"

              append_to_file(
                rollup_package_json,
                rollup_config_json,
              )
            end
          end

          def install_js_bundler
            if self.behavior == :invoke

              # Install Script 👇🏾
              puts "\nInstall rollup with config"

              rollup_config_file = "#{javascript_dir_path}/rollup.config.js"
              `touch #{rollup_config_file}`

              rollup_config_input = "./application.js"

              rollup_output_file = "app/assets/react_particles/builds/application.js"

              react_particles_builds_dir = "app/assets/react_particles/builds/"

              react_particles_builds_keep = "app/assets/react_particles/builds/.keep"

              rollup_config_json = "\n" +
              "\nimport resolve from \"@rollup/plugin-node-resolve\"" +
              "\n\nexport default {" +
              "\n  input: \"#{rollup_config_input}\"," +
              "\n  output: {" +
              "\n    file: \"#{rollup_output_file}\"," +
              "\n    format: \"es\"," +
              "\n    inlineDynamicImports: true," +
              "\n    sourcemap: true" +
              "\n  }," +
              "\n  plugins: [" +
              "\n    resolve()" +
              "\n  ]" +
              "\n}"

              append_to_file(
                rollup_config_file,
                rollup_config_json,
              )

              @install_script = File.expand_path("../rollup_templates/install.rb", __FILE__)


              Dir.chdir(javascript_dir_path) do

                # Install Script 👇🏾
                system "yarn add rollup"
                system "yarn add @rollup/plugin-node-resolve"

                system "ruby #{@install_script}"
              end
            end
          end



          def revoke_callbacks
            if self.behavior == :revoke

              chdir javascript_dir_path do
                run "yarn remove rollup @rollup/plugin-node-resolve"
                run "rm #{javascript_dir_path}/rollup.config.js"
                if (
                  Dir.exists? javascript_dir_path) and
                  (Dir.empty? javascript_dir_path
                )
                    `rmdir #{javascript_dir_path}`
                end
              end

            end
          end


          private

            # def build_script
            #   'build: "rollup --bundle ./application.js --outfile=../../assets/javascripts/react_particles/application.js'
            # end

            # def watch_script
            #   'watch: "rollup --watch --bundle ./application.js --outfile=../../assets/javascripts/react_particles/application.js"'
            # end

            def namespace
              options[:namespace]
            end

            def js_bundler
              "rollup"
            end

            def javascript_dir_path
              javascript_dir_path = "app/javascript/#{namespace}"
            end

            def package_json_file_path
              "#{javascript_dir_path}/package.json"
            end

        end
      end
    end
  end
end
