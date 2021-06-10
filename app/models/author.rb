class Author < ApplicationRecord
  has_rich_text :about
  has_one_attached :image
  has_and_belongs_to_many :events, join_table: 'authors_events'
end
