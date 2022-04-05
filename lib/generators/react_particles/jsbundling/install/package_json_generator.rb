require "rails/generators/base"
require "react_particles/generator_helpers"

module ReactParticles
  module Generators
    module Jsbundling
      module Install
        class PackageJsonGenerator < Rails::Generators::Base
          include ReactParticles::GeneratorHelpers

          source_root File.expand_path("../package_json_templates", __FILE__)

          class_option :namespace, type: :string, default: "react_application"
          class_option :js_bundler, type: :string, default: "esbuild"

          def ensure_previous_generator
              unless(Rails.root.join(src_dir_path).exist?)
                call_generator("react_particles:install:react:src", "--namespace", namespace)
              end
          end


          def copy_package_json
            previous_working_directory = File.dirname(__FILE__)

            template_file = "#{js_bundler}_package_json.json.erb"
            template_target = "#{javascript_dir_path}/package.json"

            config_template = js_bundler == 'esbuild' ? false : "#{js_bundler}.config.js.erb"
            config_template_target = js_bundler == 'esbuild' ? false : "#{javascript_dir_path}/#{js_bundler}.config.js"

            case self.behavior
            when :invoke

              if config_template
                template(
                  config_template,
                  config_template_target,
                )
              end

              template(
                template_file,
                template_target,
              )

              Dir.chdir(javascript_dir_path)

              # system `yarn add react react-dom`
              system `yarn run build`

              Dir.chdir(previous_working_directory)

            when :revoke


              # Dir.chdir(javascript_dir_path)
                system `yarn remove #{js_bundler}`
              # Dir.chdir(previous_working_directory)


              if config_template_target
                `rm #{config_template_target}`
                puts ("removed ".red) + "#{config_template_target}"
              end


              if Rails.root.join(template_target).exist?
                `rm #{template_target}`
                puts ("removed ".red) + "#{template_target}"
                `rm -rf #{javascript_dir_path}` if (Dir.exists? javascript_dir_path) and (Dir.empty? javascript_dir_path)
              else
                puts "\n\nCommand ignored:".yellow
                puts"\nfile does not exist: \n #{template_target}\n\n"
              end
            end
          end

          private

            def namespace
              options[:namespace]
            end

            def js_bundler
              options[:js_bundler]
            end

            def javascript_dir_path
              "app/javascript/#{namespace}"
            end

            def src_dir_path
              "#{javascript_dir_path}/src"
            end

            def generated_react_application_package_json_file_path
              "#{javascript_dir_path}/package.json"
            end

            def generated_react_application_package_json_file_path
              "#{javascript_dir_path}/package.json"
            end
        end
      end
    end
  end
end
