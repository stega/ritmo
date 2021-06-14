class Event < ApplicationRecord
  belongs_to :conference_session
  has_many :author_events
  has_many :authors, -> { order 'author_events.order ASC' }, through: :author_events
  has_one_attached :map
  has_one_attached :attachment

  has_rich_text :abstract

  include PgSearch::Model
  pg_search_scope :search_text,
                  against: %i[title],
                  associated_against: {
                    rich_text_abstract: [:body]
                  },
                  using: {
                    tsearch: { dictionary: "english", prefix: true }
                  }

  def self.for_date(day)
    date_range = "#{day}-06-2021 00:00:00".to_datetime.."#{day}-06-2021 23:59:59".to_datetime
    joins(:conference_session).where(conference_sessions: {start: date_range})
  end

  def event_type
    conference_session.session_type
  end
end
