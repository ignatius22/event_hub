class RecurringEventGenerator
  attr_reader :parent_event

  def initialize(parent_event)
    @parent_event = parent_event
  end

  def generate_instances
    return [] unless parent_event.recurring?
    return [] if parent_event.recurrence_rule.blank?

    instances = []
    current_date = parent_event.starts_at

    case parent_event.recurrence_rule
    when 'daily'
      instances = generate_daily_instances(current_date)
    when 'weekly'
      instances = generate_weekly_instances(current_date)
    when 'monthly'
      instances = generate_monthly_instances(current_date)
    end

    instances
  end

  private

  def generate_daily_instances(start_date)
    instances = []
    current_date = start_date + 1.day
    end_date = parent_event.recurrence_end_date || (start_date + 3.months)

    while current_date <= end_date
      instances << create_instance(current_date)
      current_date += 1.day
      break if instances.count >= 100 # Safety limit
    end

    instances
  end

  def generate_weekly_instances(start_date)
    instances = []
    current_date = start_date + 1.week
    end_date = parent_event.recurrence_end_date || (start_date + 6.months)

    while current_date <= end_date
      instances << create_instance(current_date)
      current_date += 1.week
      break if instances.count >= 52 # Safety limit
    end

    instances
  end

  def generate_monthly_instances(start_date)
    instances = []
    current_date = start_date + 1.month
    end_date = parent_event.recurrence_end_date || (start_date + 1.year)

    while current_date <= end_date
      instances << create_instance(current_date)
      current_date += 1.month
      break if instances.count >= 12 # Safety limit
    end

    instances
  end

  def create_instance(date)
    duration = parent_event.ends_at - parent_event.starts_at

    parent_event.recurring_instances.create!(
      title: parent_event.title,
      description: parent_event.description,
      location: parent_event.location,
      address: parent_event.address,
      starts_at: date,
      ends_at: date + duration,
      capacity: parent_event.capacity,
      category_id: parent_event.category_id,
      user_id: parent_event.user_id,
      status: :draft
    )
  end
end
