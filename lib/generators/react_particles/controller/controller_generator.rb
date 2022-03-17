require "react_particles/generator_helpers"

module ReactParticles
  module Generators
    class ControllerGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers
      include ReactParticles::GeneratorHelpers

      desc "Generates controller, controller_spec and views for the model with the given NAME."

      source_root File.expand_path('../templates', __FILE__)

      argument :actions, type: :array, default: [], banner: "action action"

      class_option :skip_routes, type: :boolean, desc: "Don't add routes to config/routes.rb."

      # class_option :namespace, type: :string, default: "react_application"

      # class_option :helper, type: :boolean

      check_class_collision suffix: "Controller"

      # react_particals_parent_application_controller_present? = File.exists?("app/controllers/react_application/application_controller.rb")

      def gem_controller_app_controller?
        File.exists?("app/controllers/react_application/application_controller.rb")
      end

      def install_react_application_controller_if_missing
        if gem_controller_app_controller?
          puts "\n *** ReactParticles::ApplicationController Ready *** "*3
        else
          puts "\n *** ReactParticles::ApplicationController missing *** "*3
          puts "\n ... Creating ReactParticles::ApplicationController \n"

          template(
            "application_controller.rb.erb",
            "app/controllers/react_application/application_controller.rb",
          )

          puts "\n"
          puts "\n ... Creating controller files \n"
          puts "\n"
        end
      end

      def create_controller_files
        # template "controller.rb", File.join("app/controllers", class_path, "#{file_name}_controller.rb")

        template "controller.rb", File.join("app/controllers/react_application", class_path, "#{file_name}_controller.rb")
      end

      def add_routes
        return if options[:skip_routes]
        return if actions.empty?

        routing_code = actions.map { |action| "get '#{file_name}/#{action}'" }.join("\n")
        route routing_code, namespace: regular_class_path
      end

      # hook_for :template_engine, :test_framework, :helper do |generator|
      hook_for :template_engine, :test_framework do |generator|
        invoke generator, [ remove_possible_suffix(name), actions ]
      end

      private

        def file_name
          @_file_name ||= remove_possible_suffix(super)
        end

        def remove_possible_suffix(name)
          name.sub(/_?controller$/i, "")
        end

        def namespace
          options[:namespace]
        end
        #
        # def singular_react_application_resources
        #   react_application_resources.map(&:to_s).map(&:singularize)
        # end
        #
        # def react_application_resources
        #   ReactParticles::Namespace.new(namespace).resources
        # end
    end
  end
end
