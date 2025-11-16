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
    when :draft then "bg-gray-100 text-gray-800"
    when :published then "bg-green-100 text-green-800"
    when :cancelled then "bg-red-100 text-red-800"
    when :completed then "bg-blue-100 text-blue-800"
    else "bg-gray-100 text-gray-800"
    end
  end

  def role_badge_class(role)
    case role.to_sym
    when :admin then "bg-purple-100 text-purple-800"
    when :organizer then "bg-blue-100 text-blue-800"
    when :attendee then "bg-green-100 text-green-800"
    else "bg-gray-100 text-gray-800"
    end
  end
end
