require "rails/generators/base"
require "react_particles/generator_helpers"

module ReactParticles
  module Generators
    module Jsbundling
      module Install
        class PackageJsonGenerator < Rails::Generators::Base
          include ReactParticles::GeneratorHelpers

          source_root File.expand_path("../shared_js", __FILE__)

          class_option :namespace, type: :string, default: "react_application"

          def copy_package_json
            template_file = "package.json"
            template_target = "#{javascript_dir_path}/package.json"

            case self.behavior
            when :invoke
              unless (Rails.root.join(generated_react_application_package_json_file_path).exist?)
                template(
                  template_file,
                  template_target,
                )
              else
                puts "\n\nCommand ignored:".yellow
                puts "rails generate react_particles:jsbundling:install:package_json".yellow
                puts"\nfile already exists: \n #{generated_react_application_package_json_file_path}\n\n"
              end
            when :revoke
              if Rails.root.join(template_target).exist?
                `rm #{template_target}`
                puts ("removed ".red) + "#{template_target}"
                `rm -rf #{javascript_dir_path}` if (Dir.exists? javascript_dir_path) and (Dir.empty? javascript_dir_path)
              else
                puts "\n\nCommand ignored:".yellow
                puts "rails destroy react_particles:jsbundling:install:package_json".yellow
                puts"\nfile does not exist: \n #{generated_react_application_package_json_file_path}\n\n"
              end
            end
          end

          private

            def javascript_dir_path
              javascript_dir_path = "app/javascript/#{namespace}"
            end

            def generated_react_application_package_json_file_path
              "#{javascript_dir_path}/package.json"
            end

            def namespace
              options[:namespace]
            end
        end
      end
    end
  end
end
