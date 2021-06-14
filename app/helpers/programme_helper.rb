module ProgrammeHelper
  def session_time(conf_session)
    "#{conf_session.start.to_formatted_s(:time)} - #{conf_session.end.to_formatted_s(:time)}"
  end
end