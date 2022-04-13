require "rails/generators/base"
require "react_particles/generator_helpers"

module ReactParticles
  module Generators
    module Jsbundling
      module Install
        class RollupGenerator < Rails::Generators::Base
          include ReactParticles::GeneratorHelpers

          source_root File.expand_path("../rollup_templates", __FILE__)

          class_option :namespace, type: :string, default: "react_application"
          class_option :js_bundler, type: :string, default: "rollup"

          # def ensure_react_particles_js
          #   call_generator("react_particles:install:assets")
          # end

          def ensure_javascript_dir_path
            unless Rails.root.join(javascript_dir_path).exist?
              # `mkdir #{javascript_dir_path}`
              # `touch #{javascript_dir_path}/application.js`
                call_generator("react_particles:install:assets")
            end
          end

          def install_js_bundler
            if self.behavior == :invoke

              # Install Script 👇🏾
              puts "\nInstall #{js_bundler} with config"

              bundler_config_file = "#{javascript_dir_path}/#{js_bundler}.config.js"
              `touch #{bundler_config_file}`

              bundler_config_input_path = "./application.js"
              bundler_config_output_path = "app/assets/javascripts/react_particles/application.js" # BG

              bundler_config_content = "\n" +
              "\nimport resolve from \"@rollup/plugin-node-resolve\"" +
              "\n\nexport default {" +
              "\n  input: \"#{bundler_config_input_path}\"," +
              "\n  output: {" +
              "\n    file: \"#{bundler_config_output_path}\"," +
              "\n    format: \"es\"," +
              "\n    inlineDynamicImports: true," +
              "\n    sourcemap: true" +
              "\n  }," +
              "\n  plugins: [" +
              "\n    resolve()" +
              "\n  ]" +
              "\n}"

              append_to_file(
                bundler_config_file,
                bundler_config_content,
              )

              install_script = File.expand_path("../rollup_templates/install.rb", __FILE__)


              Dir.chdir(javascript_dir_path) do
                # Install Script 👇🏾
                system "yarn add rollup @rollup/plugin-node-resolve"
                # system "yarn add rollup"
                # system "yarn add @rollup/plugin-node-resolve"
                # system "yarn add rollup-plugin-jsx"
                # system "yarn add @rollup/plugin-typescript"
                system "ruby #{install_script}"
              end
            end
          end

          def revoke_callbacks
            if self.behavior == :revoke

              Dir.chdir(javascript_dir_path) do
                run "yarn remove rollup @rollup/plugin-node-resolve"
                run "rm #{javascript_dir_path}/rollup.config.js"
                if (
                  Dir.exists? javascript_dir_path) and
                  (Dir.empty? javascript_dir_path
                )
                    `rmdir #{javascript_dir_path}`
                end
              end

            end
          end

          #############################################################
          #############################################################
          #############################################################
          # def generate_bundler_config_file
          #   # bundler_config_file = "rollup.config.js"
          #
          #     case self.behavior
          #     when :invoke
          #       bundler_config_file = "#{javascript_dir_path}/#{js_bundler}.config.js"
          #       `touch #{bundler_config_file}`
          #
          #       # bundler_config_input_file = "./application.js" #OG
          #       bundler_config_input_file = "#{javascript_dir_path}/application.js" #BG
          #       # bundler_config_output_file = "app/assets/react_particles/builds/application.js" # OG
          #       bundler_config_output_file = "app/assets/javascripts/react_particles/application.js" # BG
          #
          #       rollup_config_js = "\n"                                 +
          #       "\nimport resolve from \"@rollup/plugin-node-resolve\"" +
          #       "\n\nexport default {"                                  +
          #       "\n  input: \"#{bundler_config_input_file}\","          +
          #       "\n  output: {"                                         +
          #       "\n    file: \"#{bundler_config_output_file}\","        +
          #       "\n    format: \"es\","                                 +
          #       "\n    inlineDynamicImports: true,"                     +
          #       "\n    sourcemap: true"                                 +
          #       "\n  },"                                                +
          #       "\n  plugins: ["                                        +
          #       "\n    resolve()"                                       +
          #       "\n  ]"                                                 +
          #       "\n}"
          #       append_to_file(
          #         bundler_config_file,
          #         rollup_config_js,
          #       )
          #     when :revoke
          #       `rm #{bundler_config_file}`
          #     end
          # end
          #
          #
          #
          # def install_js_bundler
          #   install_script = File.expand_path("../rollup_templates/install.rb", __FILE__)
          #
          #
          #   Dir.chdir(javascript_dir_path) do
          #     case self.behavior
          #     when :invoke
          #       system `yarn add #{js_bundler}`
          #       system `yarn add @rollup/plugin-node-resolve`
          #       system "ruby #{install_script}"
          #     when :revoke
          #       system `yarn remove #{js_bundler}`
          #       # system `yarn remove @rollup/plugin-node-resolve`
          #     end
          #   end
          # end
          #############################################################
          #############################################################
          #############################################################
          #############################################################



          # # TODO split into seperate methods
          # # TODO split into seperate methods
          # # TODO split into seperate methods
          # def install_js_bundler
          #   bundler_config_file = "#{javascript_dir_path}/rollup.config.js"
          #
          #   case self.behavior
          #   when :invoke
          #     ### Install Script from jsbundling-rails 👇🏾
          #     ### /jsbundling-rails/lib/install/rollup/install.rb
          #     puts "\nInstall rollup with config"
          #     `touch #{bundler_config_file}`
          #
          #     # bundler_config_input_file = "./application.js" #OG
          #     bundler_config_input_file = "#{javascript_dir_path}/application.js" #BG
          #     # bundler_config_output_file = "app/assets/react_particles/builds/application.js" # OG
          #     bundler_config_output_file = "app/assets/javascripts/react_particles/application.js" # BG
          #
          #     rollup_config_js = "\n" +
          #     "\nimport resolve from \"@rollup/plugin-node-resolve\"" +
          #     "\n\nexport default {" +
          #     "\n  input: \"#{bundler_config_input_file}\"," +
          #     "\n  output: {" +
          #     "\n    file: \"#{bundler_config_output_file}\"," +
          #     "\n    format: \"es\"," +
          #     "\n    inlineDynamicImports: true," +
          #     "\n    sourcemap: true" +
          #     "\n  }," +
          #     "\n  plugins: [" +
          #     "\n    resolve()" +
          #     "\n  ]" +
          #     "\n}"
          #
          #     append_to_file(
          #       bundler_config_file,
          #       rollup_config_js,
          #     )
          #
          #     Dir.chdir(javascript_dir_path) do
          #       # # Install Script from jsbundling-rails 👇🏾
          #       # system "yarn add rollup"
          #       # system "yarn add @rollup/plugin-node-resolve"
          #
          #       system "yarn add rollup @rollup/plugin-node-resolve"
          #
          #       puts "Add build script"
          #       build_script = "rollup -c rollup.config.js"
          #
          #
          #       if (`npx -v`.to_f < 7.1 rescue "Missing")
          #         puts %(Add "scripts": { "build": "#{build_script}" } to your package.json), :green
          #       else
          #         system %(npm set-script build "#{build_script}")
          #         system %(yarn build)
          #       end
          #     end
          #
          #   when :revoke
          #     Dir.chdir(javascript_dir_path) do
          #       # # Install Script from jsbundling-rails 👇🏾
          #       system "yarn remove rollup"
          #       system "yarn remove @rollup/plugin-node-resolve"
          #       system `rm #{bundler_config_file}`
          #     end
          #   end
          # end

          # def revoke_callbacks
          #   if self.behavior == :revoke
          #
          #     Dir.chdir(javascript_dir_path) do
          #       system `yarn remove @rollup/plugin-node-resolve`
          #       system `yarn remove rollup`
          #
          #       system `rm #{javascript_dir_path}/rollup.config.js`
          #       if (
          #         Dir.exists? javascript_dir_path) and
          #         (Dir.empty? javascript_dir_path
          #       )
          #           `rmdir #{javascript_dir_path}`
          #       end
          #     end
          #   end
          # end

          private
            # def build_script
            #   'build: "rollup --bundle ./application.js --outfile=../../assets/javascripts/react_particles/application.js'
            # end

            def namespace
              options[:namespace]
            end

            def js_bundler
              "rollup"
            end

            def javascript_dir_path
              "app/javascript/#{namespace}"
            end
        end
      end
    end
  end
end
