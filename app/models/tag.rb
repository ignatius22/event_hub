class Tag < ApplicationRecord
  has_many :event_tags, dependent: :destroy
  has_many :events, through: :event_tags

  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true

  before_validation :generate_slug

  scope :popular, -> { joins(:events).group('tags.id').order('COUNT(events.id) DESC') }

  private

  def generate_slug
    self.slug = name.to_s.parameterize if name.present?
  end
end
