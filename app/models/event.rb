class Event < ApplicationRecord
  has_rich_text :abstract
  has_and_belongs_to_many :authors
  has_one_attached :map
  has_one_attached :attachment

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
