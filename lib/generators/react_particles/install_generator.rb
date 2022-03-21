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

#########################################################
#########################################################
####### How to reverse a 'rails generate' ***************
####### https://stackoverflow.com/questions/4161357/how-to-reverse-a-rails-generate

####### It's worth mentioning the -p flag here ("p" for pretend)
#######     If you add this to the command it will simply do a
#######    "test" run and show you what files will be deleted
#######     without actually deleting them.
#########################################################
#########################################################


######################################################################################
######################################################################################
####### Rails generator not removing newly created folders on destroy ***************
####### https://stackoverflow.com/questions/52881285/rails-generator-not-removing-newly-created-folders-on-destroy

####### def generate_directory
#######   case self.behavior
#######   when :invoke
#######     `mkdir path/to/directory`
#######   when :revoke
#######     `rm -rf path/to/directory`
#######   end
####### end
######################################################################################
######################################################################################


      # def copy_initializer
      #   template "react_particles.rb", "config/initializers/react_particles.rb"
      # end

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
          puts indent_str("removed ".red) + react_particles_initializer_file_path.green
          `rm #{react_particles_initializer_file_path}`
        end
      end



      def generate_assets
        call_generator("react_particles:assets:javascripts")
        call_generator("react_particles:assets:stylesheets")
      end



      ############################################################
      ############################################################
      ############################################################
      #### **************** Adding esbuild and other dependencies
      def generate_javascript_dir
        javascript_dir_path = "app/javascript/#{namespace}"

        case self.behavior
        when :invoke
          `mkdir #{javascript_dir_path}`
        when :revoke
          `rm -rf #{javascript_dir_path}`
          puts indent_str("removed ".red) + "#{javascript_dir_path.green}/*"
        end
      end


      def generate_package_json_file_in_namespaced_js_dir
        javascript_dir_path = "app/javascript/#{namespace}"

        react_application_package_json_template_file = "package_json_template.json.erb"
        generated_react_application_package_json_file_path = "#{javascript_dir_path}/package.json"

        case self.behavior
        when :invoke
          template(
            react_application_package_json_template_file,
            generated_react_application_package_json_file_path,
          )
        when :revoke
          puts indent_str("removed ".red) + generated_react_application_package_json_file_path.green
          `rm -rf #{generated_react_application_package_json_file_path}`
        end
      end




      def generate_nested_components_file
        javascript_components_file_path = "app/javascript/#{namespace}/components.jsx"

        case self.behavior
        when :invoke
          `touch #{javascript_components_file_path}`
        when :revoke
          `rm -rf #{javascript_components_file_path}`
          puts indent_str("removed ".red) + "#{javascript_components_file_path.green}"
        end
      end

      # def generate_namespace_js_dependencies
      #   # code
      # end

      #### *******************************************************
      ############################################################
      ############################################################
      ############################################################







      # def create_react_application_controller
      #   template(
      #     "application_controller.rb.erb",
      #     "app/controllers/#{namespace}/application_controller.rb",
      #   )
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
          puts indent_str("removed ".red) + "app/controllers/#{namespace}/*".green
          puts indent_str("removed ".red) + generated_react_application_controller_file_path.green
          `rm -rf app/controllers/#{namespace}/`
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
          puts indent_str("removed ".red) + generated_components_controller_file_path.green
          `rm -rf path/to/directory`
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
          puts indent_str("removed ".red) + components_view_template_file.green
          `rm -rf app/views/#{namespace}/`
        end
      end

      # def create_react_application_routes
      #   # if react_application_resources.none?
      #   #   call_generator("react_particles:routes", "--namespace", namespace)
      #   #   Rails.application.reload_routes!
      #   # end
      # end

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
