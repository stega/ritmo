class ConferenceSession < ApplicationRecord
  has_many :events

  def self.for_date(day)
    date_range = "#{day}-06-2021 00:00:00".to_datetime.."#{day}-06-2021 23:59:59".to_datetime
    where(conference_sessions: {start: date_range}).order(:start)
  end

  def self.filter_by_type(type)
    where(session_type: type)
  end

  def self.filter_by_kw(kw)
    includes(:events).joins(:events).where("? = ANY (events.keywords)", kw)
  end

  def self.event_count
    joins(:events).sum{|cs| cs.events.size}
  end

  def self.search(search_term)
    ids = Event.search_text(search_term).pluck(:id)
    joins(:events).where('events.id IN (?)', ids)
  end
end
