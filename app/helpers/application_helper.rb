module ApplicationHelper
  def active_tab(link)
    return link == controller_name ? 'active' : ''
  end

  def is_admin?
    current_user && current_user.admin?
  end
end
