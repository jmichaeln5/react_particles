require "rails/generators/base"
require "react_particles/generator_helpers"
# require "react_particles/namespace"

module ReactParticles
  module Generators
    module Jsbundling
      class SharedJsGenerator < Rails::Generators::Base
        include ReactParticles::GeneratorHelpers

        source_root File.expand_path("../shared_js", __FILE__)

        class_option :namespace, type: :string, default: "react_application"

        #### Runs Install script from js-bundling
        #### Runs Install script from js-bundling
        #### Runs Install script from js-bundling
        #### Runs Install script from js-bundling
        #### Runs Install script from js-bundling

          # puts "Compile into app/assets/builds"
          # empty_directory "app/assets/builds"
          # keep_file "app/assets/builds"

############################################################### *******     CURRENT WIP
############################################################### *******     CURRENT WIP
############################################################### *******     CURRENT WIP
################# *******     WIP     ******* #################
################# *******     WIP     ******* #################
################# *******     WIP     ******* #################

          # if (sprockets_manifest_path = Rails.root.join("app/assets/config/react_particles_manifest.js")).exist?
          #   append_to_file sprockets_manifest_path, %(//= link_tree ../javascripts/react_particles\n)
          # else
          #   sprockets_manifest_path = "app/assets/config/react_particles_manifest.js"
          #   system `touch `
          #   append_to_file sprockets_manifest_path, %(//= link_tree ../javascripts/react_particles\n)
          # end

          def append_react_particles_javascript_to_manifest
            sprockets_manifest_path = "app/assets/config/react_particles_manifest.js"

            if Rails.root.join(sprockets_manifest_path).exist?
              append_to_file(sprockets_manifest_path, "\n //= link_tree ../javascripts/react_particles \n")
            else
              system "touch #{sprockets_manifest_path}"
              append_to_file(sprockets_manifest_path, "//= link_tree ../javascripts/react_particles \n")
            end
          end




          # # This l00ks like this block could be trouble, see 👀  below...
          # unless (Rails.root.join("#{react_app_js_path}/application.js")).exist?
          #   puts "Create default entrypoint in #{react_app_js_path}/application.js"
          #   # empty_directory react_app_js_path.parent.to_s # 👀
          #   copy_file "#{__dir__}/application.js", react_app_js_path
          # end


          def append_entry_point_text
            react_app_js_file_path = "#{react_app_js_path}/application.js"

            unless(Rails.root.join(react_app_js_file_path)).exist?
              system `touch #{react_app_js_file_path}`
            end
            append_to_file react_app_js_file_path, %(// Entry point for the build script in your package.json)
          end


          # unless (app_js_package_json_path = Rails.root.join("#{react_app_js_path}/package.json")).exist?
          #   puts "Add React Particles default package.json"
          #   copy_file "#{__dir__}/package.json", app_js_package_json_path
          # end

          def create_react_app_package_json_unless_exists
            react_app_package_json_template = "package_json_template.json.erb"
            react_app_package_json_file_path = "#{react_app_js_path}/package.json"

            unless(Rails.root.join(react_app_package_json_file_path)).exist?
              template(
                react_app_package_json_template,
                react_app_package_json_file_path,
              )
            end
            # case self.behavior
            # when :invoke
            #   template(
            #     react_app_package_json_template,
            #     react_app_package_json_file_path,
            #   )
            # when :revoke
            #   puts indent_str("removed ".red) + react_app_package_json_file_path
            #   `rm -rf #{react_app_js_path}`
            # end
          end







          def append_yarn_commands_to_proc
            proc_file_template = "Procfile.dev"
            proc_file_path = Rails.root

            if Rails.root.join(proc_file_template).exist?
              append_to_file proc_file_template, "js: yarn build --watch\n"
            else
              puts "Add default Procfile.dev"
              template(
                proc_file_template,
                proc_file_path,
              )
              # copy_file "#{__dir__}/Procfile.dev", "Procfile.dev"
            end
            # if Rails.root.join("Procfile.dev").exist?
            #   append_to_file "Procfile.dev", "js: yarn build --watch\n"
            # else
            #   puts "Add default Procfile.dev"
            #
            #   copy_file "#{__dir__}/Procfile.dev", "Procfile.dev"
          end


          def add_bin_dev_start_to_foreman
            dev_file_template = "dev"
            dev_file_path = Rails.root("bin")

            puts "Ensure foreman is installed"

            system "gem install foreman"

            puts "Add bin/dev to start foreman"

            template(
              dev_file_template,
              "#{dev_file_path}/dev",
            )

            # copy_file "#{__dir__}/dev", "bin/dev"
            chmod "bin/dev", 0755, verbose: false


            # puts "Ensure foreman is installed"
            # run "gem install foreman"
            #
            # puts "Add bin/dev to start foreman"
            #
            # copy_file "#{__dir__}/dev", "bin/dev"
            # chmod "bin/dev", 0755, verbose: false
          end





###############################################################
###############################################################
###############################################################



        private

          def namespace
            options[:namespace]
          end

          def react_app_js_path
            "app/javascript/#{namespace}"
          end

      end
    end
  end
end
