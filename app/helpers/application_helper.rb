module ApplicationHelper
  include Pagy::Frontend

  def flash_class(level)
    case level.to_sym
    when :notice, :success then "bg-green-100 border-green-400 text-green-700"
    when :alert, :error then "bg-red-100 border-red-400 text-red-700"
    when :warning then "bg-yellow-100 border-yellow-400 text-yellow-700"
    else "bg-blue-100 border-blue-400 text-blue-700"
    end
  end

  def format_date(date)
    date.strftime("%B %d, %Y")
  end

  def format_time(time)
    time.strftime("%I:%M %p")
  end

  def format_datetime(datetime)
    datetime.strftime("%B %d, %Y at %I:%M %p")
  end

  def status_badge_class(status)
    case status.to_sym
    when :draft then "bg-warm-100 text-warm-700 border border-warm-200"
    when :published then "bg-emerald-50 text-emerald-700 border border-emerald-200"
    when :cancelled then "bg-rose-50 text-rose-700 border border-rose-200"
    when :completed then "bg-sky-50 text-sky-700 border border-sky-200"
    else "bg-warm-100 text-warm-700 border border-warm-200"
    end
  end

  def role_badge_class(role)
    case role.to_sym
    when :admin then "bg-violet-50 text-violet-700 border border-violet-200"
    when :organizer then "bg-sky-50 text-sky-700 border border-sky-200"
    when :attendee then "bg-emerald-50 text-emerald-700 border border-emerald-200"
    else "bg-warm-100 text-warm-700 border border-warm-200"
    end
  end
end
