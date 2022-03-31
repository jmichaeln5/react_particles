require "rails/generators/base"
require "react_particles/generator_helpers"
require "react_particles/namespace"

module ReactParticles
  module Generators
    module Jsbundling
      class SharedJsGenerator < Rails::Generators::Base
        include ReactParticles::GeneratorHelpers
        source_root File.expand_path("../jsbundling_templates", __FILE__)

        class_option :namespace, type: :string, default: "react_application"
        class_option :js_bundler, type: :string, default: "esbuild"

        #### Runs Install script from js-bundling
        #### Runs Install script from js-bundling
        #### Runs Install script from js-bundling
        #### Runs Install script from js-bundling
        #### Runs Install script from js-bundling

          # say "Compile into app/assets/builds"
          # empty_directory "app/assets/builds"
          # keep_file "app/assets/builds"


          if (sprockets_manifest_path = Rails.root.join("app/assets/config/react_particles_manifest.js")).exist?
            append_to_file sprockets_manifest_path, %(//= link_tree ../javascripts/react_particles\n)
          end


          unless (app_js_entrypoint_path = Rails.root.join("app/javascript/#{namespace}/application.js")).exist?
            say "Create default entrypoint in app/javascript/#{namespace}/application.js"
            empty_directory app_js_entrypoint_path.parent.to_s
            copy_file "#{__dir__}/application.js", app_js_entrypoint_path
          end


          unless Rails.root.join("app/javascript/#{namespace}/package.json").exist?
            say "Add React Particles default package.json"
            copy_file "#{__dir__}/package.json", "package.json"
          end



          if Rails.root.join("Procfile.dev").exist?
            append_to_file "Procfile.dev", "js: yarn build --watch\n"
          else
            say "Add default Procfile.dev"
            copy_file "#{__dir__}/Procfile.dev", "Procfile.dev"

            say "Ensure foreman is installed"
            run "gem install foreman"
          end


          say "Add bin/dev to start foreman"
          copy_file "#{__dir__}/dev", "bin/dev"
          chmod "bin/dev", 0755, verbose: false



        private

          def app_react_particles_rake_tasks_dir
            return "lib/tasks/react_particles"
          end

          def output_js_bundler_path
            return "#{app_react_particles_rake_tasks_dir}/output_js_bundler.rake"
          end

          def host_app_js_root_path
            return Rails.root.join("app/javascript/#{namespace}")
          end

          def namespace
            options[:namespace]
          end

      end
    end
  end
end
