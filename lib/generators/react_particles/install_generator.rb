require "rails/generators/base"
require "react_particles/generator_helpers"
require "react_particles/namespace"

module ReactParticles
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include ReactParticles::GeneratorHelpers
      # source_root File.expand_path("../templates", __FILE__) # before
      source_root File.expand_path("../../templates", __FILE__)

      class_option :namespace, type: :string, default: "react_application"
        # e.g. with namespace
          # rails g react_particles:install --namespace reakt_app
          # creates: app/controllers/reakt_app/application_controller.rb

        # e.g. without namespace
          # rails g react_particles:install
          # creates: app/controllers/react_application/application_controller.rb

      def create_react_application_controller
        template(
          "application_controller.rb.erb",
          "app/controllers/#{namespace}/application_controller.rb",
        )
      end

      def create_default_components_controller
        template(
          "components_controller.rb.erb",
          "app/controllers/#{namespace}/components_controller.rb",
        )
      end

      def create_default_components_view
        template(
          "components_index.rb.erb",
          "app/views/#{namespace}/components/index.html.erb",
        )
      end


      # def create_react_application_routes
      #   # if react_application_resources.none?
      #   #   call_generator("react_particles:routes", "--namespace", namespace)
      #   #   Rails.application.reload_routes!
      #   # end
      # end

      def create_react_application_routes
        # route "resources :people" # works
        # route "resources :posts, module: 'admin' " # works

        # route "scope #{namespace.to_sym} do \n" \
        #       "   get 'components/index'\n"\
        #       "end\n\n"



        #### works under route: localhost:3000/react_particles/components/index
        # route "scope module: '#{namespace}' do \n" \
        #       "   get 'components/index'\n"\
        #       "end\n\n"


        route "scope module: '#{namespace}' do \n" \
              "   get 'components/index'\n"\
              "end\n\n"



        Rails.application.reload_routes!
      end




      # def create_react_application_views
      #   # code
      # end

      private

      def namespace
        options[:namespace]
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
