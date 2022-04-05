# require "rails/generators/base"
#
# module ReactParticles
#   module Generators
#     module Jsbundling
#       module Install
#         class JsbundlerHelpers < Rails::Generators::Base
#
#           source_root File.expand_path("../shared_js", __FILE__)
#
#           class_option :namespace, type: :string, default: "react_application"
#           class_option :js_bundler, type: :string, default: "esbuild"
#
#           def ensure_package_json # allows generator to run alone
#             unless (Rails.root.join(generated_react_application_package_json_file_path).exist?)
#               call_generator("react_particles:jsbundling:install:package_json", "--namespace", namespace)
#             end
#           end
#
#
#           private
#
#             def javascript_dir_path
#               javascript_dir_path = "app/javascript/#{namespace}"
#             end
#
#             def generated_react_application_package_json_file_path
#               "#{javascript_dir_path}/package.json"
#             end
#
#             def generated_react_application_package_json_file_path
#               "#{javascript_dir_path}/package.json"
#             end
#
#             def namespace
#               options[:namespace]
#             end
#
#             def js_bundler
#               options[:js_bundler]
#             end
#
#         end
#       end
#     end
#   end
# end
