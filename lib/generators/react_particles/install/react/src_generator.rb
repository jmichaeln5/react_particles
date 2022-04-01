require "rails/generators/base"
require "react_particles/generator_helpers"
require "react_particles/namespace"

module ReactParticles
  module Generators
    module Install
      module React
        class SrcGenerator < Rails::Generators::Base
          include ReactParticles::GeneratorHelpers
          source_root File.expand_path("../src_templates", __FILE__)

          class_option :namespace, type: :string, default: "react_application"

          unless(Dir.exists? react_app_js_path)
            # system `mkdir #{react_app_js_path}`
            system `mkdir #{Rails.root.join(react_app_js_path)}`
          end

          unless(Dir.exists? src_dir_path)
            system `mkdir #{Rails.root.join(src_dir_path)}`
          end

          def copy_src
            src_template_dir_path = "../src_templates"

            case self.behavior
            when :invoke
              directory src_template_dir_path, src_dir_path
            when :revoke
              `rm -rf #{src_dir_path}` if (Dir.exists? src_dir_path)
              if (Dir.exists? src_dir_path)
                append_to_file "Procfile.dev", "js: yarn build --watch\n"
                puts indent_str("removed ".red) + "#{src_dir_path}/*"
              end
            end
          end

          private
            def namespace
              options[:namespace]
            end

            def src_dir_path
              # src_dir_path = "app/javascript/#{namespace}/src"
              src_dir_path = "#{react_app_js_path}/src"
            end

            # def react_app_js_path
            #   return Rails.root.join("app/javascript/#{namespace}")
            # end

        end
      end
    end
  end
end
