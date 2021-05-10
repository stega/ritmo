module WorkshopsHelper
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

  def workshop_time(workshop)
    start = workshop.time_start.to_formatted_s(:time)
    endtime = end_time(workshop)

    return "#{start} - #{endtime.to_formatted_s(:time)}"
  end

  def workshop_datetime_start(workshop)
    "2021-06-#{workshop.date}T#{workshop.time_start.hour}:#{workshop.time_start.min.to_s.rjust(2, '0')}:00.000+02:00"
  end
  def workshop_datetime_end(workshop)
    "2021-06-#{workshop.date}T#{end_time(workshop).hour}:#{end_time(workshop).min.to_s.rjust(2, '0')}:00.000+02:00"
  end

  def end_time(workshop)
    case workshop.duration
    when '15 min'
      end_time = workshop.time_start + 15.minutes
    when '30 min'
      end_time = workshop.time_start + 30.minutes
    when '45 min'
      end_time = workshop.time_start + 45.minutes
    when '1 hr'
      end_time = workshop.time_start + 1.hour
    when '2 hr'
      end_time = workshop.time_start + 2.hour
    end
    return end_time
  end
end
