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

          ################################################################################################################
          ################################################################################################################
          ################################################################################################################
          ### NOTE CHOOSE WHICH STYLE OF INSTALL, USE AMONGST ALL JSBUNDLER INSTALL GENERATORS
          ### NOTE CHOOSE WHICH STYLE OF INSTALL, USE AMONGST ALL JSBUNDLER INSTALL GENERATORS
          ### NOTE CHOOSE WHICH STYLE OF INSTALL, USE AMONGST ALL JSBUNDLER INSTALL GENERATORS
          ############################ Installs esbuild with JSON template file
          def generate_package_json
            template_file = "package_json_template.json.erb"
            generated_template_file = "#{javascript_dir_path}/package.json"

            case self.behavior
            when :invoke
              unless (Rails.root.join(template_file)).exist?
                template(
                  template_file,
                  generated_template_file,
                )
              end
            when :revoke
              puts indent_str("removed ".red) + generated_template_file
              `rm -rf #{javascript_dir_path}`
            end
          end

          def install_react_es_build
            generated_template_file = "#{javascript_dir_path}/package.json"

            case self.behavior
            when :invoke
              if (Rails.root.join(generated_template_file)).exist?
                Dir.chdir "#{javascript_dir_path}" do
                    # system 'yarn add react react-dom esbuild'
                    system 'yarn add esbuild'
                    system 'yarn run build'
                end
              end
            when :revoke
              if ( generated_json_file_path = Rails.root.join(generated_template_file)).exist?
                Dir.chdir "#{javascript_dir_path}" do
                  # system 'yarn remove react react-dom esbuild'
                  system 'yarn remove esbuild'
                end
                `rm -rf #{javascript_dir_path}` if (Dir.exists? javascript_dir_path) and (Dir.empty? javascript_dir_path)
              end
            end
          end
          ### NOTE CHOOSE WHICH STYLE OF INSTALL, USE AMONGST ALL JSBUNDLER INSTALL GENERATORS
          ### NOTE CHOOSE WHICH STYLE OF INSTALL, USE AMONGST ALL JSBUNDLER INSTALL GENERATORS
          ### NOTE CHOOSE WHICH STYLE OF INSTALL, USE AMONGST ALL JSBUNDLER INSTALL GENERATORS
          ############################ Installs esbuild with jsbundling install script and manually configured JSON
          # def create_package_json
          #   if self.behavior == :invoke
          #     esbuild_package_json = "#{javascript_dir_path}/package.json"
          #     `touch #{esbuild_package_json}`
          #
          #     esbuild_config_json ="
          #     \n{" +
          #     "\n  \"name\": \"#{namespace}\", " +
          #     "\n  \"private\": \"true\"" +
          #     "\n}"
          #
          #     append_to_file(
          #       esbuild_package_json,
          #       esbuild_config_json,
          #     )
          #   end
          # end
          #
          # def install_js_bundler
          #   if self.behavior == :invoke
          #     ### Install Script from jsbundling-rails 👇🏾
          #     ### /jsbundling-rails/lib/install/esbuild/install.rb
          #     install_script = File.expand_path("../esbuild_templates/install.rb", __FILE__)
          #
          #     Dir.chdir(javascript_dir_path) do
          #       # Install Script from jsbundling-rails 👇🏾
          #       system "ruby #{install_script}"
          #     end
          #   end
          # end
          ################################################################################################################
          ################################################################################################################
          ################################################################################################################

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
