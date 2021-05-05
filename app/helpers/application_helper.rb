module ApplicationHelper
  def active_tab(link)
    return link == controller_name ? 'active' : ''
  end

  def is_admin?
    current_user && current_user.admin?
  end

  def user_profile_pic(user)
    if user.image.representable?
      return image_tag(user.image, class:'profile')
    else
      return image_tag('/profile.png')
    end
  end

  def user_name(user)
    user.name || user.email
  end
end
