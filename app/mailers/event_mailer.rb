class EventMailer < ApplicationMailer
  def registration_confirmation(registration)
    @registration = registration
    @event = registration.event
    @user = registration.user

    mail(
      to: @user.email,
      subject: "You're registered for #{@event.title}"
    )
  end

  def event_reminder(registration)
    @registration = registration
    @event = registration.event
    @user = registration.user

    mail(
      to: @user.email,
      subject: "Reminder: #{@event.title} is coming up!"
    )
  end

  def event_cancelled(registration)
    @registration = registration
    @event = registration.event
    @user = registration.user

    mail(
      to: @user.email,
      subject: "Event Cancelled: #{@event.title}"
    )
  end
end
