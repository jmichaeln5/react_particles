require "rails/generators/base"
require "react_particles/generator_helpers"

module ReactParticles
  module Generators
    module Jsbundling
      module Install
        class WebpackGenerator < Rails::Generators::Base
          include ReactParticles::GeneratorHelpers

          source_root File.expand_path("../webpack_templates", __FILE__)

          class_option :namespace, type: :string, default: "react_application"
          class_option :js_bundler, type: :string, default: "webpack"

          def ensure_react_particle_assets
            react_particles_builds_dir = "app/assets/react_particles/builds"
            react_particles_builds_keep = "app/assets/react_particles/builds/.keep"
            react_app_js = "#{javascript_dir_path}/application.js"

            case self.behavior
            when :invoke
              call_generator("react_particles:install:assets")

              `mkdir #{Rails.root.join(react_particles_builds_dir)}` unless Rails.root.join(react_particles_builds_dir).exist?
              `touch #{Rails.root.join(react_particles_builds_keep)}` unless Rails.root.join(react_particles_builds_keep).exist?
              `touch #{Rails.root.join(react_app_js)}` unless Rails.root.join(react_app_js).exist?

            when :revoke

              `rm #{react_particles_builds_keep}` if Rails.root.join(react_particles_builds_keep).exist?
              `rm -rf #{react_particles_builds_dir}` if (Dir.exists? react_particles_builds_dir) and (Dir.empty? react_particles_builds_dir)
              `rm #{react_app_js}` if Rails.root.join(react_app_js).exist?

            end
          end

          def ensure_javascript_dir_path
            unless Rails.root.join(javascript_dir_path).exist?
              `mkdir #{javascript_dir_path}`
            end
          end

          def generate_package_json
            template_file = "#{javascript_dir_path}/package.json"

            case self.behavior
            when :invoke
              `touch #{template_file}` unless Rails.root.join(template_file).exist?

              generated_template_file =
                %( { ) +
                %(\n  "name": "app", ) +
                %(\n  "private": "true" ) +
                %(\n} )

              append_to_file(
                template_file,
                generated_template_file,
              )
            when :revoke
              `rm #{template_file}` if (File.exists? template_file)
              puts indent_str("removed ".red) + template_file
            end
          end

          def install_js_bundler
            if behavior == :invoke
              ### Install Script from jsbundling-rails 👇🏾
              ### /jsbundling-rails/lib/install/webpack/install.rb
              puts "\nInstall webpack with config"

              webpack_config_file = "#{javascript_dir_path}/webpack.config.js"
              `touch #{webpack_config_file}`

              webpack_config_input = "./application.js"
              webpack_output_file = "app/assets/react_particles/builds/application.js"

              webpack_config_json =
              "const path = require(\"path\") "                                   +
              "\nconst webpack = require(\"webpack\") "                           +

              "\n\nmodule.exports = { "                                           +
              "\nmode: \"production\","                                           +
              "\ndevtool: \"source-map\","                                        +
              "\n  entry: { "                                                     +
              "\n    application: \"#{webpack_config_input}\""                    +
              "\n  }, "                                                           +
              "\n  output: { "                                                    +
              "\n    filename: \"[name].js\", "                                   +
              "\n    sourceMapFilename: \"[name].js.map\", "                      +
              "\n    path: path.resolve(__dirname, \"#{webpack_output_file}\"), " +
              "\n  }, "                                                           +
              "\n  plugins: [  "                                                  +
              "\n      new webpack.optimize.LimitChunkCountPlugin({ "             +
              "\n       maxChunks: 1"                                             +
              "\n      }) "                                                       +
              "\n  ]"                                                             +
              "\n}"

              append_to_file(
                webpack_config_file,
                webpack_config_json,
              )

              install_script = File.expand_path("../webpack_templates/install.rb", __FILE__)

              Dir.chdir(javascript_dir_path) do
                # Install Script from jsbundling-rails 👇🏾
                # system "yarn add webpack"
                # system "yarn add webpack-cli"

                system "ruby #{install_script}"
              end
            end
          end

          def revoke_callbacks
            if behavior == :revoke
              run "yarn remove webpack webpack-cli"
              run "rm #{javascript_dir_path}/webpack.config.js"

              Dir.chdir(javascript_dir_path) do
                if (
                  Dir.exists? javascript_dir_path) and
                  (Dir.empty? javascript_dir_path
                )
                  `rm -rf #{javascript_dir_path}` if (Dir.exists? javascript_dir_path) and (Dir.empty? javascript_dir_path)
                end
              end

            end
          end

          private
            def namespace
              options[:namespace]
            end

            def js_bundler
              "webpack"
            end

            def javascript_dir_path
              javascript_dir_path = "app/javascript/#{namespace}"
            end

            def package_json_file_path
              "#{javascript_dir_path}/package.json"
            end
        end
      end
    end
  end
end
