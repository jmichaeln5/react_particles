### NOTE MAIN INSTALL GENERATOR
### NOTE MAIN INSTALL GENERATOR
### NOTE MAIN INSTALL GENERATOR

require "rails/generators/base"
require "react_particles/generator_helpers"
require "react_particles/namespace"

module ReactParticles
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include ReactParticles::GeneratorHelpers
      source_root File.expand_path("../install/templates", __FILE__)
      class_option :namespace, type: :string, default: "react_application"
      class_option :js_bundler, type: :string, default: "esbuild"

      ENGINE_APP_ROOT = File.expand_path("../../../../app", __dir__)
      HOST_APP_ROOT = Rails.root.join("app")

      def generate_react_particles_initializer
        react_particles_initializer_template_file = "react_particles.rb"
        react_particles_initializer_file_path = "config/initializers/react_particles.rb"

        case self.behavior
        when :invoke
          template(
            react_particles_initializer_template_file,
            react_particles_initializer_file_path,
          )
        when :revoke
          `rm #{react_particles_initializer_file_path}`
          puts indent_str("\nremoved ".red) + react_particles_initializer_file_path + "\n"
        end
      end

      def run_assets_generator
        call_generator("react_particles:install:assets")
      end

      def run_react_generator
        call_generator("react_particles:install:react", "--namespace", namespace)
      end

      def run_js_bundling_rake_task_generators
        call_generator("react_particles:install:start", "--namespace", namespace)
        call_generator("react_particles:jsbundling:build", "--namespace", namespace)
        call_generator("react_particles:jsbundling:clobber")
      end

      ## (Here to test js_bundler class_option) Call method in:
      ## lib/generators/react_particles/jsbundling/install_generator.rb
      # def run_output_js_bundler_generator
      #   call_generator("react_particles:jsbundling:output_js_bundler", "--js_bundler", js_bundler)
      #   puts "*"*50
      #   puts "*"*50
      #   puts "run_output_js_bundler_generator \n"*4
      #   puts "*"*50
      #   puts "*"*50
      # end

      def generate_react_application_controller
        react_application_controller_template_file = "application_controller.rb.erb"
        generated_react_application_controller_file_path = "app/controllers/#{namespace}/application_controller.rb"

        case self.behavior
        when :invoke
          template(
            react_application_controller_template_file,
            generated_react_application_controller_file_path,
          )
        when :revoke
          puts indent_str("removed ".red) + "app/controllers/#{namespace}/*"
          puts indent_str("removed ".red) + generated_react_application_controller_file_path
          `rm -rf app/controllers/#{namespace}/`
        end
      end

      def generate_react_particles_application_layout
        engine_app_application_html_erb_path = File.expand_path("../../../../app/views/layouts/react_particles/application.html.erb", __FILE__)

        case self.behavior
        when :invoke
          copy_file(
            engine_app_application_html_erb_path,
            "app/views/layouts/#{namespace}/application.html.erb",
          )
        when :revoke
          puts indent_str("removed ".red) + "app/views/layouts/#{namespace}/*"
          `rm -rf app/views/layouts/#{namespace}/`
        end
      end

      def generate_default_components_controller
        components_controller_template_file = "components_controller.rb.erb"
        generated_components_controller_file_path = "app/controllers/#{namespace}/components_controller.rb"

        case self.behavior
        when :invoke
          template(
            components_controller_template_file,
            generated_components_controller_file_path,
          )
        when :revoke
          puts indent_str("removed ".red) + generated_components_controller_file_path
          `rm -rf app/controllers/#{namespace}`
        end
      end

      def generate_default_components_view
        components_view_template_file = "components_index.rb.erb"
        generated_components_view_file_path = "app/views/#{namespace}/components/index.html.erb"

        case self.behavior
        when :invoke
          template(
            components_view_template_file,
            generated_components_view_file_path,
          )
        when :revoke
          puts indent_str("removed ".red) + components_view_template_file
          `rm -rf app/views/#{namespace}/`
        end
      end

      def generate_react_application_routes
        react_application_routes =  "scope module: '#{namespace}' do \n" \
                                    "   get 'components/index'\n"\
                                    "end\n\n"
        case self.behavior
        when :invoke
          route(react_application_routes)
        when :revoke
          puts indent_str("removed ".red)
          route(react_application_routes)
        end

        Rails.application.reload_routes!
      end

      def show_readme
        readme "README" if behavior == :invoke
      end

      private

        def namespace
          options[:namespace]
        end

        def js_bundler
          options[:js_bundler]
        end

        def singular_react_application_resources
          react_application_resources.map(&:to_s).map(&:singularize)
        end

        def react_application_resources
          ReactParticles::Namespace.new(namespace).resources
        end

    end
  end
end
