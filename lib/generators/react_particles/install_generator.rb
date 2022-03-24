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
        # call_generator("react_particles:assets:javascripts")
        call_generator("react_particles:assets:stylesheets")
      end

      ############################################################
      ################## **************** ReactParticles JS ASSETS
      ASSETS_JAVASCRIPTS_DIR_PATH = "app/assets/javascripts/react_particles"
      def generate_react_particles_assets_javascripts_dir
         case self.behavior
         when :invoke
           say "Creating react_particles javascripts directory, entry point for Engine's Asset Pipeline"
           `mkdir #{ASSETS_JAVASCRIPTS_DIR_PATH}`
         when :revoke
           say "Removing react_particles javascripts entry point for Asset Pipeline"
           `rm -rf #{ASSETS_JAVASCRIPTS_DIR_PATH}`
         end
      end

      ASSETS_JAVASCRIPTS_APP_JS_FILE_PATH = ASSETS_JAVASCRIPTS_DIR_PATH + "/application.js"
      def generate_react_particles_assets_javascripts_application_js
         case self.behavior
         when :invoke
           say "Creating react_particles javascripts application.js file, entry point for Engine's Asset Pipeline"
           `touch #{ASSETS_JAVASCRIPTS_APP_JS_FILE_PATH}`
         when :revoke
           say "Removing react_particles javascripts application.js file"
           `rm #{ASSETS_JAVASCRIPTS_APP_JS_FILE_PATH}`
         end
      end

      ASSETS_CONFIG_MANIFEST_FILE_PATH = "app/assets/config/react_particles_manifest.js"
      def generate_react_particles_assets_manifest_js
        case self.behavior
        when :invoke
          say "Creating react_particles javascripts react_particles_manifest.js file, entry point for Engine's Asset Pipeline"
          `mkdir app/assets/config`
          `touch #{ASSETS_CONFIG_MANIFEST_FILE_PATH}`
        when :revoke
          `rm #{ASSETS_CONFIG_MANIFEST_FILE_PATH}`
          puts indent_str("removed ".red) + "#{ASSETS_CONFIG_MANIFEST_FILE_PATH.green}"
        end
        if (sprockets_manifest_path = Rails.root.join(ASSETS_CONFIG_MANIFEST_FILE_PATH)).exist?
          append_to_file sprockets_manifest_path, %(//= link_tree ../javascripts/react_particles\n)
        end
      end
      ################## *****************************************
      ############################################################


      ############################################################
      #### **************** Adding esbuild and other dependencies
      def generate_namespaced_javascript_dir
        javascript_dir_path = "app/javascript/#{namespace}"

        case self.behavior
        when :invoke
          `mkdir #{javascript_dir_path}`
        when :revoke
          `rm -rf #{javascript_dir_path}`
          puts indent_str("removed ".red) + "#{javascript_dir_path.green}/*"
        end
      end

      def generate_namespaced_application_js_in_javascript_dir
        javascript_dir_path = "app/javascript/#{namespace}"

        javascript_application_js_file_in_js_dir = "app/javascript/#{namespace}/application.js"

        case self.behavior
        when :invoke
          `touch #{javascript_application_js_file_in_js_dir}`
            append_to_file(javascript_application_js_file_in_js_dir, "import './components.jsx' \n")
        when :revoke
          `rm -rf #{javascript_dir_path}`
          puts indent_str("removed ".red) + "#{javascript_dir_path.green}/*"
        end
      end

      def generate_package_json_file_in_namespaced_javascript_dir
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
          `rm -rf #{javascript_dir_path}`
        end
      end

      def generate_components_file
        javascript_dir_path = "app/javascript/#{namespace}"
        javascript_components_file_path = "#{javascript_dir_path}/components.jsx"
        case self.behavior
        when :invoke
          template(
            "component_template.js.erb",
            javascript_components_file_path,
          )
        when :revoke
          puts indent_str("removed ".red) + "#{javascript_components_file_path.green}"
          `rm -rf #{javascript_dir_path}`
        end
      end

      def install_react_es_build_with_yarn
        javascript_dir_path = "app/javascript/#{namespace}"
        generated_react_application_package_json_file_path = "#{javascript_dir_path}/package.json"

        case self.behavior
        when :invoke
          if ( generated_json_file_path = Rails.root.join(generated_react_application_package_json_file_path)).exist?
            Dir.chdir "#{javascript_dir_path}" do
                system 'yarn add react react-dom esbuild'
            end
          end
        when :revoke
          if ( generated_json_file_path = Rails.root.join(generated_react_application_package_json_file_path)).exist?
            Dir.chdir "#{javascript_dir_path}" do
                system 'yarn remove react react-dom esbuild'
            end
            `rm -rf #{javascript_dir_path}`
          end
        end
      end

      def add_node_modules_to_git_ignore
        react_particles_node_modules = "/app/javascript/#{namespace}/node_modules"
        removed_react_particles_node_modules_path = "app/javascript/___namespace___/node_modules"
        case self.behavior
        when :invoke
          if Rails.root.join(".gitignore").exist?
            append_to_gitignore("#{react_particles_node_modules}/*")
          else
            system "touch .gitignore"
            append_to_gitignore("#{react_particles_node_modules}/*")
          end
        when :revoke
          puts "\n"
          puts "*"*50
          puts "*"*50
          puts "\n"
          puts "#{removed_react_particles_node_modules_path} removed, please remove reference of file in .gitignore"
          puts "\n"
          puts "*"*50
          puts "*"*50
          puts "\n"
        end
      end
      ################## *****************************************
      ############################################################

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

      def generate_react_application_layout
        case self.behavior
        when :invoke
          copy_file(
            "../../../app/views/layouts/react_particles/application.html.erb",
            "app/views/layouts/#{namespace}/application.html.erb",
          )
        when :revoke
          puts indent_str("removed ".red) + "app/views/layouts/#{namespace}/*".green
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
          puts indent_str("removed ".red) + generated_components_controller_file_path.green
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
          puts indent_str("removed ".red) + components_view_template_file.green
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

      private

      def namespace
        options[:namespace]
      end

      def append_to_gitignore(file)
        if Rails.root.join(".gitignore").exist?
          append_to_file(".gitignore", "\n #{file} \n")
        else
          system "touch .gitignore"
          append_to_file(".gitignore", "\n #{file} \n")
        end
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
