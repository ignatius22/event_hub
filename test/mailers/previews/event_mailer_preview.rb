# Preview all emails at http://localhost:3000/rails/mailers/event_mailer
class EventMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/event_mailer/registration_confirmation
  def registration_confirmation
    EventMailer.registration_confirmation
  end

  # Preview this email at http://localhost:3000/rails/mailers/event_mailer/event_reminder
  def event_reminder
    EventMailer.event_reminder
  end

end
