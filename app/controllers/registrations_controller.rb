class RegistrationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:create]
  before_action :set_registration, only: [:destroy]

  def create
    @registration = current_user.registrations.build(event: @event, status: :confirmed)

    if @event.full?
      @registration.status = :waitlisted
    end

    authorize @registration

    if @registration.save
      respond_to do |format|
        format.html { redirect_to @event, notice: registration_success_message }
        format.turbo_stream
      end
    else
      redirect_to @event, alert: @registration.errors.full_messages.to_sentence
    end
  end

  def destroy
    authorize @registration
    @event = @registration.event
    @registration.destroy

    respond_to do |format|
      format.html { redirect_to @event, notice: "Your registration has been cancelled." }
      format.turbo_stream
    end
  end

  def my_registrations
    @registrations = current_user.registrations
                                 .includes(event: [:category, :user])
                                 .joins(:event)
                                 .order("events.starts_at ASC")
    @pagy, @registrations = pagy(@registrations)
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def set_registration
    @registration = current_user.registrations.find(params[:id])
  end

  def registration_success_message
    if @registration.waitlisted?
      "You've been added to the waitlist."
    else
      "You've successfully registered for this event!"
    end
  end
end
