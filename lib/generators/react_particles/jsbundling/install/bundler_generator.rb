require "rails/generators/base"
require "react_particles/generator_helpers"

module ReactParticles
  module Generators
    module Jsbundling
      module Install
        class BundlerGenerator < Rails::Generators::Base
          include ReactParticles::GeneratorHelpers

          source_root File.expand_path("../shared_js", __FILE__)

          class_option :namespace, type: :string, default: "react_application"
          class_option :js_bundler, type: :string, default: "esbuild"

          def ensure_package_json # allows generator to run alone
            unless (Rails.root.join(generated_react_application_package_json_file_path).exist?)
              call_generator("react_particles:jsbundling:install:package_json", "--namespace", namespace)
            end
          end

          def install_js_bundler
            js_bundler_install_path = "#{js_bundler}/install.rb"
            js_bundler_config_path = js_bundler == "esbuild" ? false : "#{js_bundler}/#{js_bundler}.config.js"

            case self.behavior

            when :invoke

              puts "Copying #{js_bundler} install script in #{javascript_dir_path}...\n"

              copy_file js_bundler_install_path, javascript_dir_path

              # template(
              #   js_bundler_install_path,
              #   javascript_dir_path,
              # )

              if js_bundler_config_path
                template(
                  js_bundler_config_path,
                  javascript_dir_path,
                )
              end

              byebug

                Dir.chdir "#{javascript_dir_path}" do
                  puts "Installing #{js_bundler}...\n\n"
                  system `ruby #{js_bundler_install_path}`
                  # puts "#{js_bundler} installed successfully \n"
                  # puts "Removing #{js_bundler_install_path}\n"
                end

                  system `yarn run build`

                  puts "\n"*3
                  puts ("*"*50 + "\n")*3
                  puts "*"*10 + " Yarn run build " + "*"*10
                  puts ("*"*50 + "\n")*3
                  puts "\n"*3

                  # system `yarn add react react-dom`
                  #
                  # puts "\n"*3
                  # puts ("*"*50 + "\n")*3
                  # puts "*"*10 + " Yarn added react react-dom " + "*"*10
                  # puts ("*"*50 + "\n")*3
                  # puts "\n"*3

            when :revoke
              if (Rails.root.join(generated_react_application_package_json_file_path).exist?)
                Dir.chdir "#{javascript_dir_path}" do
                    system `yarn remove react react-dom #{js_bundler}`
                end
                `rm -rf #{javascript_dir_path}`
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

            def generated_react_application_package_json_file_path
              "#{javascript_dir_path}/package.json"
            end

            def namespace
              options[:namespace]
            end

            def js_bundler
              options[:js_bundler]
            end

        end
      end
    end
  end
end
