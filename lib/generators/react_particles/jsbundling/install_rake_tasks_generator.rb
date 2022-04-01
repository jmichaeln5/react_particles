require "rails/generators/base"
require "react_particles/generator_helpers"
require "react_particles/namespace"

module ReactParticles
  module Generators
    module Jsbundling
      class InstallRakeTasksGenerator < Rails::Generators::Base
        include ReactParticles::GeneratorHelpers

        class_option :namespace, type: :string, default: "react_application"
        class_option :js_bundler, type: :string, default: "esbuild"

        def run_jsbundling_rake_task_generators
          call_generator("react_particles:jsbundling:clobber")
          call_generator("react_particles:jsbundling:build", "--namespace", namespace)
          call_generator("react_particles:jsbundling:output_js_bundler", "--js_bundler", js_bundler)
        end

        private

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
