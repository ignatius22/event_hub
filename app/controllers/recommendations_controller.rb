class RecommendationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @recommended_events = recommend_events_for(current_user)
  end

  private

  def recommend_events_for(user)
    # Get categories of events user has registered for or bookmarked
    user_categories = user.registered_events.pluck(:category_id).uniq +
                      user.bookmarked_events.pluck(:category_id).uniq

    # Get tags of events user interacted with
    user_tag_ids = EventTag.where(
      event_id: user.registered_events.pluck(:id) + user.bookmarked_events.pluck(:id)
    ).pluck(:tag_id).uniq

    # Find similar events
    recommended = Event.published.upcoming
      .where.not(id: user.registered_events.pluck(:id))
      .left_joins(:event_tags)
      .where('events.category_id IN (?) OR event_tags.tag_id IN (?)',
             user_categories.presence || [0],
             user_tag_ids.presence || [0])
      .group('events.id')
      .order('COUNT(event_tags.id) DESC, events.starts_at ASC')
      .limit(10)

    # If no recommendations, return popular upcoming events
    if recommended.empty?
      recommended = Event.published.upcoming
        .left_joins(:registrations)
        .group('events.id')
        .order('COUNT(registrations.id) DESC')
        .limit(10)
    end

    recommended
  end
end
