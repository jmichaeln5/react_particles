require "rails/generators/base"
require "react_particles/generator_helpers"
require 'fileutils'

module ReactParticles
  module Generators
    module Jsbundling
      module Install
        class SharedJsGenerator < Rails::Generators::Base
        include ReactParticles::GeneratorHelpers

        source_root File.expand_path("../shared_js", __FILE__)

        class_option :namespace, type: :string, default: "react_application"
        class_option :js_bundler, type: :string, default: "esbuild"

        ### NOTE Allows for generator to be ran as standalone generator
        ### Duplicated from:
        ### lib/generators/react_particles/jsbundling/install/shared_js_generator.rb
        APP_ASSETS_CONFIG_DIR = "app/assets/config"
        APP_ASSETS_JAVASCRIPTS_DIR = "app/assets/javascripts"

        APP_ASSETS_JAVASCRIPTS_REACT_PARTICLES_DIR = "#{APP_ASSETS_JAVASCRIPTS_DIR}/react_particles"
        REACT_PARTICLES_APP_JS_FILE = "#{APP_ASSETS_JAVASCRIPTS_REACT_PARTICLES_DIR}/application.js"
        REACT_PARTICLES_MANIFEST_JS_FILE = "#{APP_ASSETS_CONFIG_DIR}/react_particles_manifest.js"

        def ensure_react_app_assets
          unless(
          (Dir.exists? APP_ASSETS_CONFIG_DIR) and
          (Dir.exists? APP_ASSETS_JAVASCRIPTS_DIR) and
          (Dir.exists? APP_ASSETS_JAVASCRIPTS_REACT_PARTICLES_DIR) and
          (Dir.exists? REACT_PARTICLES_APP_JS_FILE) and
          (Dir.exists? REACT_PARTICLES_MANIFEST_JS_FILE)
          )
            call_generator("react_particles:install:assets")
          end
        end

        def ensure_procfile
          template_file = "Procfile.dev"
          template_target = "/Procfile.dev"

          case self.behavior
          when :invoke
            unless (Rails.root.join(template_file).exist?)
              template(
                template_file,
                template_target,
              )
            else
              puts "\n\nCommand ignored:".yellow
              puts "rails generate react_particles:jsbundling:install:shared_js".yellow
              puts"\nfile already exists: \n #{template_file}\n\n"
            end
          when :revoke
            if Rails.root.join(template_target).exist?
              `rm #{template_target}`
              puts ("removed ".red) + "#{template_target}"
              if (Dir.exists? javascript_dir_path) and (Dir.empty? javascript_dir_path)
                `rm -rf #{javascript_dir_path}`
              end
            else
              puts "\n\nCommand ignored:".yellow
              puts "rails destroy react_particles:jsbundling:install:shared_js".yellow
              puts"\nfile does not exist: \n #{template_file}\n\n"
            end
          end
        end



        # def ensure_procfile
        #   template_file = "Procfile.dev"
        #   template_target = "/Procfile.dev"
        #
        #   proc_file_cmds = [
        #     "js: yarn build --watch"
        #   ]
        #   case self.behavior
        #   when :invoke
        #     if Rails.root.join(template_file).exist?
        #       puts "\n\n#{template_file} already exists\nAppending React Particles #{template_file} commands to #{template_file}\n"
        #       proc_file_cmds.each do  |val|
        #         print ("\n#{val.green} appeneded to #{template_file}") and append_to_file(template_file, "\n #{val} \n")
        #       end
        #       puts "\n\n"
        #     else
        #       copy_file "./Procfile.dev", "Procfile.dev"
        #     end
        #
        #   when :revoke
        #     if Rails.root.join('Procfile.dev').exist?
        #       if file_empty?('Procfile.dev')
        #         `rm Procfile.dev`
        #         puts ("\nremoved ".red + 'Procfile.dev' + "\n")
        #       else
        #         ### https://stackoverflow.com/questions/16638667/how-do-i-remove-lines-of-data-in-the-middle-of-a-text-file-with-ruby
        #         open('Procfile.dev', 'r') do |file|
        #           open('Procfile.dev.tmp', 'w') do |tmp_file|
        #             file.each_line do |line|
        #               unless (
        #               (line.start_with? "js: yarn build --watch") or
        #               (line.start_with? " js: yarn build --watch")
        #               )
        #                 tmp_file.write(line)
        #               end
        #             end
        #           end
        #         end
        #         FileUtils.mv 'Procfile.dev.tmp', 'Procfile.dev'
        #         if file_empty?('Procfile.dev') # re-checking if file empty after removing lines
        #           `rm Procfile.dev`
        #           puts ("\nremoved ".red) + 'Procfile.dev' + "\n"
        #         else
        #           puts "\n"
        #           proc_file_cmds.each do  |val|
        #             puts ("#{val.green} removed from #{template_file}")
        #           end
        #           puts "\n"
        #         end
        #       end
        #     else
        #       puts "\n\nWARNING from: react_particles:jsbundling:install:shared_js\nCommand ignored, file does not exist:".yellow
        #       puts"#{template_target}\n\n".red
        #     end
        #   end
        # end

        def ensure_foreman
          if self.behavior == :invoke
            puts "\nEnsure foreman is installed"
            system "gem install foreman"
          end
        end

        def ensure_valid_foreman_start_with_bin_dev # will not build if yarn isn't installed, TODO check jsbundling-rails build and compare with react_particles:jsbundling:build template file
          if self.behavior == :invoke
            bin_dev_path = Rails.root.join("bin/dev")
            puts "Add bin/dev to start foreman"

            copy_file "./dev", "bin/dev"
            `chmod -R 0755 #{bin_dev_path}`
          end
        end

        private

          def namespace
            options[:namespace]
          end

          def js_bundler
            options[:js_bundler]
          end

          def javascript_dir_path
            javascript_dir_path = "app/javascript/#{namespace}"
          end

          def file_empty?(file_path)
            !(File.file?(file_path) && !File.zero?(file_path))
          end

        end
      end
    end
  end
end
