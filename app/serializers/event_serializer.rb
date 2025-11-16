class EventSerializer
  include JSONAPI::Serializer

  attributes :id, :title, :description, :location, :address,
             :latitude, :longitude, :starts_at, :ends_at,
             :capacity, :status

  attribute :category do |event|
    {
      id: event.category.id,
      name: event.category.name
    }
  end

  attribute :organizer do |event|
    {
      id: event.user.id,
      name: event.user.full_name,
      email: event.user.email
    }
  end

  attribute :registration_count do |event|
    event.registrations.confirmed.count
  end

  attribute :available_spots do |event|
    event.available_spots
  end

  attribute :is_full do |event|
    event.full?
  end

  attribute :can_register do |event|
    event.can_register?
  end

  attribute :cover_image_url do |event|
    if event.cover_image.attached?
      Rails.application.routes.url_helpers.rails_blob_url(event.cover_image, only_path: true)
    end
  end

  attribute :attendees, if: proc { |_record, params| params && params[:detailed] } do |event|
    event.registrations.confirmed.includes(:user).map do |registration|
      {
        id: registration.user.id,
        name: registration.user.full_name
      }
    end
  end
end
