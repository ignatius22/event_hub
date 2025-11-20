class CheckInsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event

  def new
    authorize_organizer
    @registrations = @event.registrations.confirmed.includes(:user)
  end

  def create
    authorize_organizer
    @registration = @event.registrations.find_by(qr_code_token: params[:token])

    if @registration
      if @registration.check_in!
        render json: { success: true, message: "#{@registration.user.full_name} checked in successfully!" }
      else
        render json: { success: false, message: 'Failed to check in.' }, status: :unprocessable_entity
      end
    else
      render json: { success: false, message: 'Invalid QR code.' }, status: :not_found
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def authorize_organizer
    unless @event.user == current_user || current_user.admin?
      redirect_to @event, alert: 'Not authorized.'
    end
  end
end
