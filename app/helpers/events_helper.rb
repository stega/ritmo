module EventsHelper

  def tag_list
    ['Entrainment', 'Music Performance', 'SMS', 'Speech', 'Medical Intervention']
  end

  def type_list(selected)
    options_for_select([['Talk','Talk'],
                        ['Poster session','Poster session'],
                        ['Concert','Concert']], selected)
  end

  def date_list(selected)
    options_for_select([['22nd June', 22],
                        ['23rd June', 23],
                        ['24th June', 24],
                        ['25th June', 25]], selected)
  end

  def event_time(event)
    start = event.time_start.in_time_zone(current_user.time_zone).to_formatted_s(:time)
    endtime = end_time(event)

    return "#{start} - #{endtime.to_formatted_s(:time)}"
  end

  def event_datetime_start(event)
    "2021-06-#{event.date}T#{event.time_start.hour}:#{event.time_start.min.to_s.rjust(2, '0')}:00.000+02:00"
  end
  def event_datetime_end(event)
    "2021-06-#{event.date}T#{end_time(event).hour}:#{end_time(event).min.to_s.rjust(2, '0')}:00.000+02:00"
  end

  def end_time(event)
    time_start = event.time_start.in_time_zone(current_user.time_zone)
    case event.duration
    when '15 min'
      end_time = time_start + 15.minutes
    when '30 min'
      end_time = time_start + 30.minutes
    when '45 min'
      end_time = time_start + 45.minutes
    when '1 hr'
      end_time = time_start + 1.hour
    when '2 hr'
      end_time = time_start + 2.hour
    end
    return end_time
  end

  def make_snake(str)
    str.downcase.gsub(/\s/, '_')
  end

  def search_active()
    params[:search] && !params[:search].blank?
  end

  def filter_active()
    params[:tag] || params[:type] || search_active
  end

  def extract_yt_id(event)
    event.youtube_link.split('/').last
  end

  def vortex_embed(event)
    event.vortex_link.gsub('view-as-webpage', 'video-embed')
  end

  def link_to_zoom(session)
    if session.session_type == 'Concert'
      youtube_link = session.events.first.youtube_link
      return link_to('Watch it here', youtube_link, class:'btn-join me-sm-3', target: '_blank')
    else
      return link_to('Join on Zoom', zoom_link(session), class:'btn-join me-sm-3', target: '_blank')
    end
  end

  def zoom_link(session)
    if session.events.size > 0
      session.events.first.zoom_link
    elsif session.name.include? 'Poster blitz'
      s = ConferenceSession.find_by name: "Posters #{session.name[-1]}"
      return s.events.first.zoom_link
    else
      'https://uio.zoom.us/j/68066232139'
    end
  end
end
