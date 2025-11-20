class Registration < ApplicationRecord
  belongs_to :user
  belongs_to :event

  # Enums
  enum :status, { pending: 0, confirmed: 1, cancelled: 2, waitlisted: 3 }

  # Validations
  validates :user_id, uniqueness: { scope: :event_id, message: "has already registered for this event" }
  validate :event_has_capacity, on: :create
  validate :user_can_register, on: :create

  # Callbacks
  after_create_commit :broadcast_rsvp_update
  after_destroy_commit :broadcast_rsvp_update
  before_create :generate_qr_code_token

  # Scopes
  scope :for_event, ->(event) { where(event: event) }
  scope :checked_in, -> { where(checked_in: true) }

  # Instance methods
  def check_in!
    update(checked_in: true, checked_in_at: Time.current)
  end

  private

  def event_has_capacity
    return unless event

    if event.full? && !waitlisted?
      errors.add(:base, "Event is at full capacity")
    end
  end

  def user_can_register
    return unless event

    unless event.can_register?
      errors.add(:base, "Cannot register for this event")
    end
  end

  def broadcast_rsvp_update
    broadcast_replace_to(
      "event_#{event_id}_registrations",
      target: "event_#{event_id}_rsvp_count",
      partial: "events/rsvp_count",
      locals: { event: event }
    )
  end

  def generate_qr_code_token
    self.qr_code_token = SecureRandom.urlsafe_base64(32)
  end
end
