class Review < ApplicationRecord
  belongs_to :event
  belongs_to :user

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :user_id, uniqueness: { scope: :event_id, message: "has already reviewed this event" }
  validates :comment, length: { maximum: 1000 }, allow_blank: true

  validate :event_must_be_completed

  scope :recent, -> { order(created_at: :desc) }

  private

  def event_must_be_completed
    return unless event

    if event.end_time > Time.current
      errors.add(:base, "Cannot review an event that hasn't ended yet")
    end
  end
end
