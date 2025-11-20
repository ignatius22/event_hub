class Comment < ApplicationRecord
  belongs_to :event
  belongs_to :user

  validates :body, presence: true, length: { minimum: 1, maximum: 1000 }

  scope :recent, -> { order(created_at: :desc) }

  broadcasts_to :event
end
