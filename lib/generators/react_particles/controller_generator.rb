require 'generators/react_particles/generator_helpers'

module ReactParticles
  module Generators
    class ControllerGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers
      include ReactParticles::Generators::GeneratorHelpers

      desc "Generates controller, controller_spec and views for the model with the given NAME."

      source_root File.expand_path('../templates', __FILE__)

      def copy_controller_and_spec_files
        template "controller.rb", File.join("app/controllers", "#{controller_file_name}_controller.rb")
      end

    end
  end
end
