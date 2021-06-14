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
end
