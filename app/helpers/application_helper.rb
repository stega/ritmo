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
    return user.email if user.name.blank?
    user.name
  end

  def display_time_zone(user)
    if current_user
      Time.current.in_time_zone(current_user.time_zone).formatted_offset
    else
      '+02:00'
    end
  end
end
