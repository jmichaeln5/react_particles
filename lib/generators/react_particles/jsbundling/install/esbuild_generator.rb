require "rails/generators/base"
require "react_particles/generator_helpers"

module ReactParticles
  module Generators
    module Jsbundling
      module Install
        class EsbuildGenerator < Rails::Generators::Base
          include ReactParticles::GeneratorHelpers

          source_root File.expand_path("../esbuild_templates", __FILE__)

          class_option :namespace, type: :string, default: "react_application"
          class_option :js_bundler, type: :string, default: "esbuild"

          def ensure_react_particle_assets
            call_generator("react_particles:install:assets")

            react_particles_builds_dir = "app/assets/react_particles/builds/"
            react_particles_builds_keep = "app/assets/react_particles/builds/.keep"

            unless Rails.root.join(react_particles_builds_dir).exist?
              `mkdir #{react_particles_builds_dir}`
              `touch #{react_particles_builds_keep}`
            end
          end

          def ensure_javascript_dir_path
            unless Rails.root.join(javascript_dir_path).exist?
              `mkdir #{javascript_dir_path}`
              `touch #{javascript_dir_path}/application.js`
            end
          end

          def create_package_json
            if self.behavior == :invoke
              esbuild_package_json = "#{javascript_dir_path}/package.json"
              `touch #{esbuild_package_json}`

              esbuild_config_json ="
              \n{" +
              "\n  \"name\": \"#{namespace}\", " +
              "\n  \"private\": \"true\"" +
              "\n}"

              append_to_file(
                esbuild_package_json,
                esbuild_config_json,
              )
            end
          end

          def install_js_bundler
            if self.behavior == :invoke
              ### Install Script from jsbundling-rails 👇🏾
              ### /jsbundling-rails/lib/install/esbuild/install.rb
              install_script = File.expand_path("../esbuild_templates/install.rb", __FILE__)

              Dir.chdir(javascript_dir_path) do
                # Install Script from jsbundling-rails 👇🏾
                system "ruby #{install_script}"
              end
            end
          end

          def revoke_callbacks
            if self.behavior == :revoke

              chdir javascript_dir_path do
                run "yarn remove esbuild"
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
              "esbuild"
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
