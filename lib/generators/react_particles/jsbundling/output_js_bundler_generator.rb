require "rails/generators/base"
require "react_particles/generator_helpers"
require "react_particles/namespace"

module ReactParticles
  module Generators
    module Jsbundling
      class OutputJsBundlerGenerator < Rails::Generators::Base
        include ReactParticles::GeneratorHelpers
        source_root File.expand_path("../jsbundling_templates", __FILE__)

        class_option :js_bundler, type: :string, default: "esbuild"

        BUNDLER_OPTIONS = ['rollup', 'webpack', 'esbuild']

        def copy_react_particles_output_js_bundler_rake
          output_js_bundler_tt = "output_js_bundler.html.erb"
          output_js_bundler_path = "#{app_react_particles_rake_tasks_dir}/output_js_bundler.rake"
          case self.behavior
          when :invoke
            template(
              output_js_bundler_tt,
              output_js_bundler_path,
            )
          when :revoke
            if Rails.root.join(output_js_bundler_path).exist?
              `rm #{output_js_bundler_path}`
              puts indent_str("removed ".red) + "#{output_js_bundler_path}"
              `rm -rf #{app_react_particles_rake_tasks_dir}` if (Dir.exists? app_react_particles_rake_tasks_dir) and (Dir.empty? app_react_particles_rake_tasks_dir)
            else
              print "\n\nreact_particles:jsbundling-rails: Command ignored".yellow
              puts"\n\nfile does not exist: \n #{output_js_bundler_path}\n\n".red
            end
          end
        end

        private

          def app_react_particles_rake_tasks_dir
            return "lib/tasks/react_particles"
          end

          def js_bundler
            js_bundler_input = options[:js_bundler]
            js_bundler_input.to_s.downcase!

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
