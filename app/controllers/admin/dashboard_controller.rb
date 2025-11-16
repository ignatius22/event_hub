module Admin
  class DashboardController < BaseController
    def index
      @total_users = User.count
      @total_events = Event.count
      @total_registrations = Registration.count
      @published_events = Event.published.count

      # Recent activity
      @recent_events = Event.includes(:user, :category).order(created_at: :desc).limit(10)
      @recent_registrations = Registration.includes(:user, :event).order(created_at: :desc).limit(10)

      # Charts data
      @events_by_category = Category.joins(:events).group(:name).count
      @registrations_by_day = Registration.group_by_day(:created_at, last: 30).count
      @events_by_status = Event.group(:status).count.transform_keys { |k| Event.statuses.key(k).humanize }
      @users_by_role = User.group(:role).count.transform_keys { |k| User.roles.key(k).humanize }
    end
  end
end
