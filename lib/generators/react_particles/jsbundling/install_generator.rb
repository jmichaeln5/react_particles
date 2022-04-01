require "rails/generators/base"
require "react_particles/generator_helpers"

module ReactParticles
  module Generators
    module Jsbundling
      class InstallGenerator < Rails::Generators::Base
        include ReactParticles::GeneratorHelpers
        source_root File.expand_path("../jsbundling_templates", __FILE__)

        class_option :namespace, type: :string, default: "react_application"
        class_option :js_bundler, type: :string, default: "esbuild"

        def run_react_src_generator
          call_generator("react_particles:install:react:src", "--namespace", namespace)
        end

        # def run_output_js_bundler_generator
        #   call_generator("react_particles:jsbundling:output_js_bundler", "--js_bundler", js_bundler)
        # end

        #### Step 1 from jsbundling-rails
        def run_shared_js_generator
          call_generator("react_particles:jsbundling:shared_js")
        end

############################ NOTE # Replace with what is in lib/generators/react_particles/install/react/react_generator.rb
############################ NOTE # Replace with what is in lib/generators/react_particles/install/react/react_generator.rb
############################ NOTE # Replace with what is in lib/generators/react_particles/install/react/react_generator.rb
        ##### Step 2 from jsbundling-rails
        # def run_shared_js_generator
        #   # Configures which js bundler to install based on :js_bundler value
        #
        #   # call_generator("react_particles:jsbundling:install_bundler:#{js_bundler}", "--js_bundler", js_bundler)
        #
        #   # rails g
        #   #   react_particles:jsbundling:install_bundler:esbuild
        #   #   react_particles:jsbundling:install_bundler:rollup
        #   #   react_particles:jsbundling:install_bundler:webpack
        # end
##################################################### Completes jsbundling-rails (gem) responsibilities
##################################################### Completes jsbundling-rails (gem) responsibilities
##################################################### Completes jsbundling-rails (gem) responsibilities

        private

          def namespace
            options[:namespace]
          end

          def app_react_particles_rake_tasks_dir
            return "lib/tasks/react_particles"
          end

          def output_js_bundler_path
            "#{app_react_particles_rake_tasks_dir}/output_js_bundler.rake"
          end


          def js_bundler
            options[:js_bundler]
          end
      end
    end
  end
end
