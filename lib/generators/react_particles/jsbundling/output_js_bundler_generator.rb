require "rails/generators/base"
require "react_particles/generator_helpers"
require "react_particles/namespace"

module ReactParticles
  module Generators
    module Jsbundling
      class OutputJsBundlerGenerator < Rails::Generators::Base
        include ReactParticles::GeneratorHelpers
        source_root File.expand_path("../jsbundling_templates", __FILE__)

        class_option :namespace, type: :string, default: "react_application"
        class_option :js_bundler, type: :string, default: "esbuild"

        BUNDLER_OPTIONS = ['esbuild', 'rollup', 'webpack']

        def copy_react_particles_output_js_bundler_rake
          output_js_bundler_tt = "output_js_bundler.html.erb"
          case self.behavior
          when :invoke
            template(
              output_js_bundler_tt,
              output_js_bundler_path,
            )
          when :revoke
            puts indent_str("removed ".red) + "#{output_js_bundler_path}"
            `rm #{output_js_bundler_path}` if (File.exists? output_js_bundler_path)
          end
        end

        private

          def app_react_particles_rake_tasks_dir
            return "lib/tasks/react_particles"
          end

          def output_js_bundler_path
            return "#{app_react_particles_rake_tasks_dir}/output_js_bundler.rake"
          end

          def namespace
            options[:namespace]
          end

          def js_bundler
            js_bundler_input = options[:js_bundler]
            js_bundler_input.downcase!

            if BUNDLER_OPTIONS.include? js_bundler_input
              return js_bundler_input
            else
              system `rm #{output_js_bundler_path}`
                if (Dir.exists? app_react_particles_rake_tasks_dir) and Dir.empty?(app_react_particles_rake_tasks_dir)
                `rm -rf #{app_react_particles_rake_tasks_dir}`
                end

              raise "\n\n\n ERROR: Invalid JavaScript bundler. \n\n please run again with one of the following options: \n\n --js_bundler=esbuild \n --js_bundler=rollup \n --js_bundler=webpack\n\n\n "
            end
          end

      end
    end
  end
end
