class Author < ApplicationRecord
  has_rich_text :about
  has_one_attached :image
  has_many :author_events
  has_many :events, through: :author_events

end
