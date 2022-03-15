module ApplicationHelper
  def root_path?
    return true if (self.controller_name == 'pages') and self.action_name == 'home'
    return false
  end
end
