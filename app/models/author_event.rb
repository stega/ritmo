class AuthorEvent < ApplicationRecord
  belongs_to :author
  belongs_to :event
end