require "rails/generators/base"
require "react_particles/generator_helpers"
require "react_particles/namespace"

module ReactParticles
  module Generators
    class ReactGenerator < Rails::Generators::Base
      include ReactParticles::GeneratorHelpers
      source_root File.expand_path("../../templates", __FILE__)

      class_option :namespace, type: :string, default: "react_application"

      def generate_namespaced_javascript_dir
        case self.behavior
        when :invoke
          `mkdir #{javascript_dir_path}`
        when :revoke
          `rm -rf #{javascript_dir_path}`
          puts indent_str("removed ".red) + "#{javascript_dir_path}/*"
        end
      end

      def generate_namespaced_application_js_in_javascript_dir
        javascript_application_js_file_in_js_dir = "app/javascript/#{namespace}/application.js"

        case self.behavior
        when :invoke
          `touch #{javascript_application_js_file_in_js_dir}`
            append_to_file(javascript_application_js_file_in_js_dir, "// Entry point for the build script in your package.json' \n")
            append_to_file(javascript_application_js_file_in_js_dir, "import './components/index.jsx' \n")
        when :revoke
          `rm -rf #{javascript_dir_path}`
          puts indent_str("removed ".red) + "#{javascript_dir_path}/*"
        end
      end

      def generate_package_json_file_in_namespaced_javascript_dir
        react_application_package_json_template_file = "package_json_template.json.erb"
        generated_react_application_package_json_file_path = "#{javascript_dir_path}/package.json"

        case self.behavior
        when :invoke
          template(
            react_application_package_json_template_file,
            generated_react_application_package_json_file_path,
          )
        when :revoke
          puts indent_str("removed ".red) + generated_react_application_package_json_file_path
          `rm -rf #{javascript_dir_path}`
        end
      end

      def generate_components_file
        javascript_components_dir_path = "#{javascript_dir_path}/components"
        javascript_components_file_path = "#{javascript_components_dir_path}/index.jsx"
        case self.behavior
        when :invoke
          `mkdir #{javascript_components_dir_path}`
          template(
            "components_index_template.js.erb",
            javascript_components_file_path,
          )
        when :revoke
          puts indent_str("removed ".red) + "#{javascript_components_file_path}"
          `rm -rf #{javascript_dir_path}`
        end
      end

      def install_react_es_build_with_yarn
        generated_react_application_package_json_file_path = "#{javascript_dir_path}/package.json"

        case self.behavior
        when :invoke
          if ( generated_json_file_path = Rails.root.join(generated_react_application_package_json_file_path)).exist?
            Dir.chdir "#{javascript_dir_path}" do
                system 'yarn add react react-dom esbuild'
                system 'yarn run build'
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
        react_particles_node_modules = "#{javascript_dir_path}/node_modules"

        removed_react_particles_node_modules_path = "app/javascript/___namespace___/node_modules"
        case self.behavior
        when :invoke
          if Rails.root.join(".gitignore").exist?
            append_to_gitignore("/#{react_particles_node_modules}/*")
          else
            system "touch .gitignore"
            append_to_gitignore("#{react_particles_node_modules}/*")
          end
        when :revoke
          puts "\n"
          3.times do puts "*"*50 end
          say "The following files/dirs have been removed:\n\n"
          puts indent_str("#{removed_react_particles_node_modules_path}".green)
          say "\nPlease remove any reference to them in .gitignore file\n"
          3.times do puts "*"*50 end
          puts "\n"
        end
      end

      def run_react_src_generator
        call_generator("react_particles:react:src", "--namespace", namespace)
      end


      private

      def javascript_dir_path
        javascript_dir_path = "app/javascript/#{namespace}"
      end

      def append_to_gitignore(file)
        if Rails.root.join(".gitignore").exist?
          append_to_file(".gitignore", "\n #{file} \n")
        else
          system "touch .gitignore"
          append_to_file(".gitignore", "\n #{file} \n")
        end
      end

      def namespace
        options[:namespace]
      end
    end
  end
end
