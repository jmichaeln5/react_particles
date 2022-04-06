require "rails/generators/base"
require "react_particles/generator_helpers"

module ReactParticles
  module Generators
    module Jsbundling
      module Install
        class RollupGenerator < Rails::Generators::Base
          include ReactParticles::GeneratorHelpers

          source_root File.expand_path("../rollup_templates", __FILE__)

          class_option :namespace, type: :string, default: "react_application"
          class_option :js_bundler, type: :string, default: "rollup"

          def ensure_react_particle_assets
            react_particles_builds_dir = "app/assets/react_particles/builds"
            react_particles_builds_keep = "app/assets/react_particles/builds/.keep"
            react_app_js = "#{javascript_dir_path}/application.js"

            case self.behavior
            when :invoke
              call_generator("react_particles:install:assets")

              `mkdir #{Rails.root.join(react_particles_builds_dir)}` unless Rails.root.join(react_particles_builds_dir).exist?
              `touch #{Rails.root.join(react_particles_builds_keep)}` unless Rails.root.join(react_particles_builds_keep).exist?
              `touch #{Rails.root.join(react_app_js)}` unless Rails.root.join(react_app_js).exist?

            when :revoke

              `rm #{react_particles_builds_keep}` if Rails.root.join(react_particles_builds_keep).exist?
              `rm -rf #{react_particles_builds_dir}` if (Dir.exists? react_particles_builds_dir) and (Dir.empty? react_particles_builds_dir)
              `rm #{react_app_js}` if Rails.root.join(react_app_js).exist?

            end
          end

          def ensure_javascript_dir_path
            unless Rails.root.join(javascript_dir_path).exist?
              `mkdir #{javascript_dir_path}`
            end
          end
          
          def create_package_json
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
              ### Install Script from jsbundling-rails 👇🏾
              ### /jsbundling-rails/lib/install/rollup/install.rb
              puts "\nInstall rollup with config"

              rollup_config_file = "#{javascript_dir_path}/rollup.config.js"
              `touch #{rollup_config_file}`

              rollup_config_input = "./application.js"
              rollup_output_file = "app/assets/react_particles/builds/application.js"

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

              install_script = File.expand_path("../rollup_templates/install.rb", __FILE__)

              Dir.chdir(javascript_dir_path) do
                # Install Script from jsbundling-rails 👇🏾
                system "yarn add rollup"
                system "yarn add @rollup/plugin-node-resolve"

                system "ruby #{install_script}"
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
