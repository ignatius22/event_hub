module Api
  module V1
    class EventsController < BaseController
      skip_before_action :authenticate_api_user!, only: [:index, :show]
      before_action :set_event, only: [:show, :rsvp]

      def index
        events = Event.published.upcoming.ordered_by_date.includes(:category, :user, :registrations)

        # Apply filters
        events = events.by_category(params[:category_id]) if params[:category_id].present?
        events = events.search(params[:q]) if params[:q].present?

        pagy, events = pagy(events)

        render json: {
          events: EventSerializer.new(events).serializable_hash[:data].map { |e| e[:attributes] },
          meta: pagy_metadata(pagy)
        }
      end

      def show
        render json: {
          event: EventSerializer.new(@event, { params: { detailed: true } }).serializable_hash[:data][:attributes]
        }
      end

      def rsvp
        registration = current_api_user.registrations.build(event: @event, status: :confirmed)

        if @event.full?
          registration.status = :waitlisted
        end

        if registration.save
          render json: {
            message: registration.waitlisted? ? "Added to waitlist" : "Successfully registered",
            registration: {
              id: registration.id,
              status: registration.status,
              event_id: registration.event_id
            }
          }, status: :created
        else
          render json: { errors: registration.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_event
        @event = Event.find(params[:id])
      end
    end
  end
end
