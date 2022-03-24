# All ReactParticles controllers inherit from this
# `ReactParticles::ApplicationController`, making it the ideal place to put
# any logic you want your React application controllers to have.
#
# If you want you're free to overwrite the controller actions.

module ReactApplication
  class ApplicationController < ReactParticles::ApplicationController
    layout "react_application/application"

  end
end
