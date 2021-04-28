module ApplicationHelper
  def active_tab(link)
    return link == controller_name ? 'active' : ''
  end
end
