# All ReactParticles controllers inherit from this
# `ReactParticles::ApplicationController`, making it the ideal place to put
# any logic you want your React application controllers to have.
#
# If you want you're free to overwrite the controller actions.

#### BEFORE
#module ReactApplication
  #class ReactApplication::ApplicationController < #ReactParticles::ApplicationController
  #class ApplicationController < ReactParticles::ApplicationController
  #end
#end


#### AFTER
module ReactApplication
  class ApplicationController < ReactParticles::ApplicationController
  end
end
