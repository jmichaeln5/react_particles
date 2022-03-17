# class <%= controller_class_name %>Controller < ApplicationController
#
# end

<% module_namespacing do -%>
class <%= class_name %>Controller < ReactParticles::ApplicationController
<% actions.each do |action| -%>
  def <%= action %>
  end
<%= "\n" unless action == actions.last -%>
<% end -%>
end
<% end -%>
