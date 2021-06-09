class Workshop < ApplicationRecord
  has_rich_text :description
  belongs_to :author
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
