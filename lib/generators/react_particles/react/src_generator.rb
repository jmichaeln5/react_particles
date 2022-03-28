require "rails/generators/base"
require "react_particles/generator_helpers"
require "react_particles/namespace"

module ReactParticles
  module Generators
    module React
      class SrcGenerator < Rails::Generators::Base
        include ReactParticles::GeneratorHelpers

        source_root File.expand_path("../src_templates", __FILE__)

        class_option :namespace, type: :string, default: "react_application"

        def copy_src
          src_template_dir_path = "../src_templates"
            case self.behavior
            when :invoke
              directory src_template_dir_path, src_dir_path
            when :revoke
              `rm -rf #{src_dir_path}`
              puts indent_str("removed ".red) + "#{src_dir_path}/*"
            end
        end

        private

        def src_dir_path
          src_dir_path = "app/javascript/#{namespace}/src"
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
end
