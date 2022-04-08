require "rails/generators/base"
require "react_particles/generator_helpers"

module ReactParticles
  module Generators
    module Jsbundling
      module Install
        class SharedJsGenerator < Rails::Generators::Base
          include ReactParticles::GeneratorHelpers

          source_root File.expand_path("../shared_js", __FILE__)

          class_option :namespace, type: :string, default: "react_application"
          class_option :js_bundler, type: :string, default: "esbuild"

          # def ensure_js_assets
          #   javascripts_react_particles = "app/assets/javascripts/react_particles"
          #   bundler_outfile = "app/assets/javascripts/react_particles/application.js"
          #   if behavior == :invoke
          #     unless (
          #       Rails.root.join(javascripts_react_particles).exist? and Rails.root.join(bundler_outfile).exist?
          #     )
          #       call_generator("react_particles:install:assets:javascripts")
          #     end
          #   end
          # end

          # def generate_app_js_dir
          #   react_app_js_dir = "#{javascript_dir_path}"
          #
          #   case self.behavior
          #   when :invoke
          #     unless Rails.root.join(react_app_js_dir).exist?
          #       system `mkdir #{react_app_js_dir}`
          #     end
          #   when :revoke
          #     if Rails.root.join(react_app_js_dir).exist?
          #       system `rmdir #{react_app_js_dir}`
          #     end
          #   end
          # end
          #
          # def generate_app_js_entrypoint_path
          #   react_app_js_file = "#{javascript_dir_path}/application.js"
          #
          #   case self.behavior
          #   when :invoke
          #     unless Rails.root.join(react_app_js_file).exist?
          #       system `touch #{react_app_js_file}`
          #     end
          #   when :revoke
          #     if Rails.root.join(react_app_js_file).exist?
          #       system `rm #{react_app_js_file}`
          #     end
          #   end
          # end

          def generate_package_json
            template_file = "#{javascript_dir_path}/package.json"

            case self.behavior
            when :invoke
              unless Rails.root.join(template_file).exist?
                `touch #{template_file}`

                generated_template_file =
                  %( { ) +
                  %(\n  "name": "app", ) +
                  %(\n  "private": "true" ) +
                  %(\n} )

                append_to_file(
                  template_file,
                  generated_template_file,
                )
              end
            when :revoke
              if Rails.root.join(template_file).exist?
                `rm #{template_file}`
                puts " "*6 + "removed ".red + "#{template_file}"
              end
            end
          end

          def append_build_targets_to_gitignore
            react_particles_node_modules = "#{javascript_dir_path}/node_modules"
            # react_particles_builds_dir = "app/assets/react_particles/builds"
            # react_particles_builds_keep = "app/assets/react_particles/builds/.keep"

            case self.behavior
            when :invoke
              if Rails.root.join(".gitignore").exist?
                append_to_gitignore("/#{react_particles_node_modules}/*")
                # append_to_gitignore("/#{react_particles_builds_dir}/*")
                # append_to_gitignore("!/#{react_particles_builds_keep}/*")
              end
            when :revoke
              puts "\nThe following files/dirs have been removed:\n\n"
              puts (" "*6 + "removed ".red + "#{react_particles_node_modules}".green)
              # puts (" "*6 + "removed ".red + "#{react_particles_builds_keep}".green)
              # puts (" "*6 + "removed ".red + "#{react_particles_builds_dir}".green)
              puts "\nPlease remove any reference of them in your .gitignore file\n\n"
            end
          end

          def ensure_foreman
            if behavior == :invoke
              puts "\nEnsure foreman is installed"
              system "gem install foreman"
            end
          end

          def ensure_valid_foreman_start_with_bin_dev
            if behavior == :invoke
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
              "app/javascript/#{namespace}"
            end

            def append_to_gitignore(file)
              if Rails.root.join(".gitignore").exist?
                append_to_file(".gitignore", "\n #{file} \n")
              else
                system "touch .gitignore"
                append_to_file(".gitignore", "\n #{file} \n")
              end
            end

        end
      end
    end
  end
end



        # def copy_procfile
        #   template_file = "Procfile.dev"
        #   # template_target = "/Procfile.dev"
        #   template_target = "#{javascript_dir_path}/Procfile.dev"
        #
        #   case self.behavior
        #   when :invoke
        #     unless (Rails.root.join(template_file).exist?)
        #       template(
        #         template_file,
        #         template_target,
        #       )
        #     else
        #       puts "\n\nCommand ignored:".yellow
        #       puts "rails generate react_particles:jsbundling:install:shared_js".yellow
        #       puts"\nfile already exists: \n #{template_file}\n\n"
        #     end
        #   when :revoke
        #     if Rails.root.join(template_target).exist?
        #       `rm #{template_target}`
        #       puts ("removed ".red) + "#{template_target}"
        #       if (Dir.exists? javascript_dir_path) and (Dir.empty? javascript_dir_path)
        #         `rm -rf #{javascript_dir_path}`
        #       end
        #     else
        #       puts "\n\nCommand ignored:".yellow
        #       puts "rails destroy react_particles:jsbundling:install:shared_js".yellow
        #       puts"\nfile does not exist: \n #{template_file}\n\n"
        #     end
        #   end
        # end




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
