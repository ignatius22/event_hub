class Category < ApplicationRecord
  has_many :events, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }
  validates :description, length: { maximum: 200 }

  scope :ordered, -> { order(:name) }

  def events_count
    events.published.count
  end
end
