require "rails/generators/base"
require "react_particles/generator_helpers"
# require 'js_bundler_helpers'

module ReactParticles
  module Generators
    module Jsbundling
      module Install
        class EsbuildGenerator < Rails::Generators::Base
          include ReactParticles::GeneratorHelpers
          # include ReactParticles::JsbundlerHelpers

          # source_root File.expand_path("../shared_js/esbuild", __FILE__)
          source_root File.expand_path("../package_json_templates", __FILE__)

          class_option :namespace, type: :string, default: "react_application"
          class_option :js_bundler, type: :string, default: "esbuild"

          # def ensure_package_json # allows generator to run alone
          #   unless (Rails.root.join(generated_react_application_package_json_file_path).exist?)
          #     call_generator("react_particles:jsbundling:install:package_json", "--namespace", namespace)
          #     # system `yarn install`
          #     # system `yarn run build`
          #   end
          # end



          # def install_esbuild
          #   template_file = "install.rb"
          #   template_target = "#{javascript_dir_path}/install.rb"
          #
          #   previous_working_directory = File.dirname(__FILE__)
          #
          #   case self.behavior
          #   when :invoke
          #     template(
          #       template_file,
          #       template_target,
          #     )
          #
          #     Dir.chdir "#{javascript_dir_path}" do
          #       system `ruby #{template_target}`
          #     end
          #     Dir.chdir(previous_working_directory)
          #
          #     system `rm #{template_target}`
          #
          #
          #   when :revoke
          #     puts "\n Uninstalling esbuild..".yellow
          #
          #     Dir.chdir "#{javascript_dir_path}" do
          #       system `yarn remove #{js_bundler}`
          #     end
          #     Dir.chdir(previous_working_directory)
          #   end
          # end

          # def ensure_package_json # allows generator to run alone
          #   template_file = "#{js_bundler}_package_json.json.erb"
          #   template_target = "#{javascript_dir_path}/package.json"
          #
          #   config_template = js_bundler == 'esbuild' ? false :
          #
          #   case self.behavior
          #   when :invoke
          #     template(
          #       template_file,
          #       template_target,
          #     )
          #   when :revoke
          #     if Rails.root.join(template_target).exist?
          #       `rm #{template_target}`
          #       puts ("removed ".red) + "#{template_target}"
          #       `rm -rf #{javascript_dir_path}` if (Dir.exists? javascript_dir_path) and (Dir.empty? javascript_dir_path)
          #     else
          #       puts "\n\nCommand ignored:".yellow
          #       puts"\nfile does not exist: \n #{template_target}\n\n"
          #     end
          #   end
          # end


          private

            def build_script
              'build: "esbuild --bundle ./application.js --outfile=../../assets/javascripts/react_particles/application.js'
            end

            def watch_script
              'watch: "esbuild --watch --bundle ./application.js --outfile=../../assets/javascripts/react_particles/application.js"'
            end

            def namespace
              options[:namespace]
            end

            def js_bundler
              "esbuild"
            end

            def javascript_dir_path
              javascript_dir_path = "app/javascript/#{namespace}"
            end

            def generated_react_application_package_json_file_path
              "#{javascript_dir_path}/package.json"
            end

        end
      end
    end
  end
end
