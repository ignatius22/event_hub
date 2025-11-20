class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :events, dependent: :destroy
  has_many :registrations, dependent: :destroy
  has_many :registered_events, through: :registrations, source: :event
  has_one_attached :avatar

  # New feature associations
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_events, through: :bookmarks, source: :event
  has_many :reviews, dependent: :destroy

  # Enums
  enum :role, { attendee: 0, organizer: 1, admin: 2 }

  # Validations
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :bio, length: { maximum: 500 }
  validates :role, presence: true

  # Callbacks
  before_create :generate_api_token

  # Instance methods
  def full_name
    "#{first_name} #{last_name}"
  end

  def can_create_events?
    organizer? || admin?
  end

  def registered_for?(event)
    registrations.exists?(event: event)
  end

  def bookmarked?(event)
    bookmarks.exists?(event: event)
  end

  def reviewed?(event)
    reviews.exists?(event: event)
  end

  private

  def generate_api_token
    self.api_token = SecureRandom.hex(32)
  end
end
