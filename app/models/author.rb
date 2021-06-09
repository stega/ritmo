class Author < ApplicationRecord
  has_rich_text :about
  has_one_attached :image
  has_many :workshops
end
