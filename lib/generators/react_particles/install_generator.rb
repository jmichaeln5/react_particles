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
        call_generator("react_particles:assets:javascripts")
        call_generator("react_particles:assets:stylesheets")
      end

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
          3.times do puts "*"*50 end
          say "The following files/dirs have been removed:\n\n"
          puts indent_str("#{removed_react_particles_node_modules_path}".green)
          say "\nPlease remove any reference to them in .gitignore file:\n"
          3.times do puts "*"*50 end
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
