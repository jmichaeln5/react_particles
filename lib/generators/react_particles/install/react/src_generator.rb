require "rails/generators/base"
require "react_particles/generator_helpers"

module ReactParticles
  module Generators
    module Install
      module React
        class SrcGenerator < Rails::Generators::Base
          include ReactParticles::GeneratorHelpers

          source_root File.expand_path("../src_templates", __FILE__)

          class_option :namespace, type: :string, default: "react_application"

          def ensure_js_assets
            javascripts_react_particles = "app/assets/javascripts/react_particles"
            bundler_outfile = "app/assets/javascripts/react_particles/application.js"
            if behavior == :invoke
              unless (
                Rails.root.join(javascripts_react_particles).exist? and Rails.root.join(bundler_outfile).exist?
              )
                call_generator("react_particles:install:assets:javascripts")
              end
            end
          end

          def copy_src
            src_template_dir_path = "../src_templates"
              case self.behavior
              when :invoke
                directory src_template_dir_path, src_dir_path
              when :revoke
                `rm -rf #{src_dir_path}`
                puts indent_str("removed ".red) + "#{src_dir_path}/*"
              end
          end

          def append_index_to_react_app_js_file
            react_app_js_file = "#{javascript_dir_path}/application.js"
            if behavior == :invoke
              append_to_file(react_app_js_file, "// Entry point for the build script in your package.json' \n")
              append_to_file(react_app_js_file, "import './src/index.jsx' \n")
            end
          end

          private
            def namespace
              options[:namespace]
            end

            def javascript_dir_path
              "app/javascript/#{namespace}"
            end

            def src_dir_path
              "#{javascript_dir_path}/src"
            end
        end
      end
    end
  end
end
