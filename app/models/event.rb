class Event < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :registrations, dependent: :destroy
  has_many :attendees, through: :registrations, source: :user
  has_one_attached :cover_image

  # Enums
  enum :status, { draft: 0, published: 1, cancelled: 2, completed: 3 }

  # Validations
  validates :title, presence: true, length: { minimum: 5, maximum: 100 }
  validates :description, presence: true, length: { minimum: 20, maximum: 5000 }
  validates :location, presence: true
  validates :address, presence: true
  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validates :capacity, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 10000 }
  validate :ends_at_after_starts_at
  validate :starts_at_in_future, on: :create

  # Geocoding
  geocoded_by :address
  after_validation :geocode, if: ->(obj) { obj.address.present? && obj.address_changed? }

  # Scopes
  scope :published, -> { where(status: :published) }
  scope :upcoming, -> { where("starts_at > ?", Time.current) }
  scope :past, -> { where("ends_at < ?", Time.current) }
  scope :by_category, ->(category_id) { where(category_id: category_id) if category_id.present? }
  scope :search, ->(query) { where("title ILIKE ? OR description ILIKE ?", "%#{query}%", "%#{query}%") if query.present? }
  scope :ordered_by_date, -> { order(starts_at: :asc) }

  # Instance methods
  def available_spots
    capacity - registrations.confirmed.count
  end

  def full?
    available_spots <= 0
  end

  def can_register?
    published? && !full? && starts_at > Time.current
  end

  def organizer
    user
  end

  private

  def ends_at_after_starts_at
    return if ends_at.blank? || starts_at.blank?

    if ends_at <= starts_at
      errors.add(:ends_at, "must be after the start time")
    end
  end

  def starts_at_in_future
    return if starts_at.blank?

    if starts_at <= Time.current
      errors.add(:starts_at, "must be in the future")
    end
  end
end
