require "rails/generators/base"
require "react_particles/generator_helpers"
require "react_particles/namespace"

module ReactParticles
  module Generators
    module React
      class SrcGenerator < Rails::Generators::Base
        include ReactParticles::GeneratorHelpers

        source_root File.expand_path("../react_src_templates", __FILE__)

        class_option :namespace, type: :string, default: "react_application"

        def generate_src_dir
          case self.behavior
          when :invoke
            `mkdir #{src_dir_path}`
          when :revoke
            `rm -rf #{src_dir_path}`
            puts indent_str("removed ".red) + "#{src_dir_path}/*"
          end
        end

        def generate_app_css_in_src_dir_path
          app_css_template_file = "App.css.tt"
          generated_app_css_file_path = "#{src_dir_path}/App.css"

          case self.behavior
          when :invoke
            template(
              app_css_template_file,
              generated_app_css_file_path,
            )
          when :revoke
            puts indent_str("removed ".red) + "#{generated_app_css_file_path}"
          end
        end

        def generate_app_js_in_src_dir_path
          app_js_tt = "App.js.tt"
          generated_app_js_file_path = "#{src_dir_path}/App.jsx"

          case self.behavior
          when :invoke
            template(
              app_js_tt,
              generated_app_js_file_path,
            )
          when :revoke
            puts indent_str("removed ".red) + "#{generated_app_js_file_path}"
          end
        end

        ########################
        ########################
        # def generate_app_test_in_src_dir_path
        #   app_js_test_tt = "App.test.js.tt"
        #   generated_app_js_test_tt = "#{src_dir_path}/App.test.jsx"
        #
        #   case self.behavior
        #   when :invoke
        #     template(
        #       app_js_test_tt,
        #       generated_app_js_test_tt,
        #     )
        #   when :revoke
        #     puts indent_str("removed ".red) + "#{generated_app_js_test_tt}"
        #   end
        # end

        def generate_src_dir_index_css
          index_css_tt = "index.css.tt"
          generated_index_css_tt = "#{src_dir_path}/index.css"

          case self.behavior
          when :invoke
            template(
              index_css_tt,
              generated_index_css_tt,
            )
          when :revoke
            puts indent_str("removed ".red) + "#{generated_index_css_tt}"
          end
        end

        def generate_src_dir_index_js
          index_js_tt = "index.js.tt"
          generated_index_js_tt = "#{src_dir_path}/index.jsx"

          case self.behavior
          when :invoke
            template(
              index_js_tt,
              generated_index_js_tt,
            )
          when :revoke
            puts indent_str("removed ".red) + "#{generated_index_js_tt}"
          end
        end

        def generate_src_dir_logo_svg
          logo_svg_tt = "logo.svg.tt"
          generated_logo_svg_tt = "#{src_dir_path}/logo.svg"

          case self.behavior
          when :invoke
            template(
              logo_svg_tt,
              generated_logo_svg_tt,
            )
          when :revoke
            puts indent_str("removed ".red) + "#{generated_logo_svg_tt}"
          end
        end
        ########################
        ########################

        private

        def src_dir_path
          src_dir_path = "app/javascript/#{namespace}/src"
          # src_dir_path = "app/javascript/#{namespace}/components"
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
