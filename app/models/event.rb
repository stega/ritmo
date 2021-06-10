class Event < ApplicationRecord
  belongs_to :conference_session
  has_and_belongs_to_many :authors, join_table: 'authors_events'
  has_one_attached :map
  has_one_attached :attachment

  has_rich_text :abstract

  include PgSearch::Model
  pg_search_scope :search_text,
                  against: %i[name],
                  associated_against: {
                    rich_text_description: [:body]
                  },
                  using: {
                    tsearch: { dictionary: "english", prefix: true }
                  }
end
