require "rails/generators/base"
require "react_particles/generator_helpers"

module ReactParticles
  module Generators
    module Install
      class ReactGenerator < Rails::Generators::Base
        include ReactParticles::GeneratorHelpers

        source_root File.expand_path("../react_templates", __FILE__)

        class_option :namespace, type: :string, default: "react_application"
        class_option :js_bundler, type: :string, default: "esbuild"

        def generate_app_js_dir
          react_app_js_dir = "#{javascript_dir_path}"

          case self.behavior
          when :invoke
            unless Rails.root.join(react_app_js_dir).exist?
              system `mkdir #{react_app_js_dir}`
            end
          when :revoke
            if Rails.root.join(react_app_js_dir).exist?
              system `rmdir #{react_app_js_dir}`
            end
          end
        end

        def generate_app_js_entrypoint_path
          react_app_js_file = "#{javascript_dir_path}/application.js"

          case self.behavior
          when :invoke
            unless Rails.root.join(react_app_js_file).exist?
              system `touch #{react_app_js_file}`
            end
          when :revoke
            if Rails.root.join(react_app_js_file).exist?
              system `rm #{react_app_js_file}`
            end
          end
        end

        def run_shared_js_generator
          call_generator("react_particles:jsbundling:install:shared_js", "--namespace", namespace, "--js_bundler", js_bundler)
        end

        # def run_js_bundler_generator
        #   call_generator("react_particles:jsbundling:install:#{js_bundler}", "--namespace", namespace, "--js_bundler", js_bundler)
        # end
        #
        # def run_react_src_generator
        #   call_generator("react_particles:install:react:src", "--namespace", namespace)
        # end

        def install_react
          case self.behavior
          when :invoke
            Dir.chdir(javascript_dir_path) do
              system 'yarn add react react-dom'
              system 'yarn build'
            end
          when :revoke
            Dir.chdir(javascript_dir_path) do
              system 'yarn remove react react-dom'
              system `rm -rf node_modules`
              system `rm yarn.lock`
            end

            if (Dir.exists? javascript_dir_path) and (Dir.empty? javascript_dir_path)
              `rm -rf #{javascript_dir_path}`
            end

          end
        end

        def run_js_bundler_generator
          call_generator("react_particles:jsbundling:install:#{js_bundler}", "--namespace", namespace, "--js_bundler", js_bundler)
        end

        def run_react_src_generator
          call_generator("react_particles:install:react:src", "--namespace", namespace)
        end

        def run_install_jsbundling_rake_task_generator
          call_generator("react_particles:jsbundling:install_rake_tasks", "--namespace", namespace, "--js_bundler", js_bundler)
        end

        private

          def javascript_dir_path
            javascript_dir_path = "app/javascript/#{namespace}"
          end

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
