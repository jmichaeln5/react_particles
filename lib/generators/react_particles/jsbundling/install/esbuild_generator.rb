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

          def install_js_bundler
            case self.behavior
            when :invoke
              ### Install Script from jsbundling-rails 👇🏾
              ### /jsbundling-rails/lib/install/esbuild/install.rb
              Dir.chdir(javascript_dir_path) do
                puts "Install esbuild"
                system "yarn add esbuild"
                puts "Add build script"

                build_script = "esbuild --bundle ./application.js --outfile=../../assets/javascripts/react_particles/application.js"

                if (`npx -v`.to_f < 7.1 rescue "Missing")
                  puts %(Add "scripts": { "build": "#{build_script}" } to your package.json), :green
                else
                  system %(npm set-script build "#{build_script}")
                  system %(yarn build)
                end
              end
            when :revoke
              system 'yarn remove esbuild'
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
              "app/javascript/#{namespace}"
            end
        end
      end
    end
  end
end
