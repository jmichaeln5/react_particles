module ReactParticles
  module Generators
    class ControllerGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelper

      desc "Generates controller, controller_spec and views for the model with the given NAME."
    end
  end
end
