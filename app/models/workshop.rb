class Workshop < ApplicationRecord
  has_rich_text :description
  belongs_to :researcher
  has_one_attached :map
  has_one_attached :attachment

end
