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
            react_particles_builds_dir = "app/assets/react_particles/builds/"
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

######### NOTE CHOOSE WHICH STYLE OF INSTALL, USE AMONGST ALL JSBUNDLER INSTALL GENERATORS
################################################# Installs esbuild with JSON template file
          # def generate_package_json
          #   template_file = "package_json_template.json.erb"
          #   generated_template_file = "#{javascript_dir_path}/package.json"
          #
          #   case self.behavior
          #   when :invoke
          #     unless (Rails.root.join(template_file)).exist?
          #       template(
          #         template_file,
          #         generated_template_file,
          #       )
          #     end
          #   when :revoke
          #     `rm #{generated_template_file}`
          #     puts indent_str("removed ".red) + generated_template_file
          #   end
          # end
          #
          # def install_react_es_build
          #   generated_template_file = "#{javascript_dir_path}/package.json"
          #
          #   case self.behavior
          #   when :invoke
          #     if (Rails.root.join(generated_template_file)).exist?
          #       Dir.chdir "#{javascript_dir_path}" do
          #           # system 'yarn add react react-dom esbuild'
          #           system 'yarn add esbuild'
          #           system 'yarn run build'
          #       end
          #     end
          #   when :revoke
          #     if ( generated_json_file_path = Rails.root.join(generated_template_file)).exist?
          #       Dir.chdir "#{javascript_dir_path}" do
          #         # system 'yarn esbuild remove react react-dom'
          #         system 'yarn remove esbuild'
          #       end
          #     end
          #   end
          # end
######### NOTE CHOOSE WHICH STYLE OF INSTALL, USE AMONGST ALL JSBUNDLER INSTALL GENERATORS
############## Installs esbuild with jsbundling install script and manually configured JSON
          def generate_package_json
            template_file = "#{javascript_dir_path}/package.json"

            case self.behavior
            when :invoke
              `touch #{template_file}` unless Rails.root.join(template_file).exist?

              generated_template_file =
                %( { ) +
                %(\n  "name": "app", ) +
                %(\n  "private": "true" ) +
                %(\n} )

              append_to_file(
                template_file,
                generated_template_file,
              )
            when :revoke
              `rm #{template_file}` if (File.exists? template_file)
              puts indent_str("removed ".red) + template_file
            end
          end

          def install_js_bundler
            case self.behavior
            when :invoke
              ### Install Script from jsbundling-rails 👇🏾
              ### /jsbundling-rails/lib/install/esbuild/install.rb
              install_script = File.expand_path("../esbuild_templates/install.rb", __FILE__)

              Dir.chdir(javascript_dir_path) do
                # Install Script from jsbundling-rails 👇🏾
                system "ruby #{install_script}"
              end
            when :revoke
              system 'yarn remove esbuild'
            end
          end
######### NOTE END
#######################################

          def revoke_callbacks
            if behavior == :revoke
              Dir.chdir(javascript_dir_path) do
                if (
                  Dir.exists? javascript_dir_path) and
                  (Dir.empty? javascript_dir_path
                )
                  `rm -rf #{javascript_dir_path}` if (Dir.exists? javascript_dir_path) and (Dir.empty? javascript_dir_path)
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
