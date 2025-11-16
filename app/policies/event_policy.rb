class EventPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    record.published? || owner_or_admin?
  end

  def create?
    user&.can_create_events?
  end

  def new?
    create?
  end

  def update?
    owner_or_admin?
  end

  def edit?
    update?
  end

  def destroy?
    owner_or_admin?
  end

  def publish?
    owner_or_admin? && record.draft?
  end

  def cancel?
    owner_or_admin? && record.published?
  end

  class Scope < Scope
    def resolve
      if user&.admin?
        scope.all
      elsif user&.organizer?
        scope.where(user: user).or(scope.published)
      else
        scope.published
      end
    end
  end

  private

  def owner_or_admin?
    user&.admin? || record.user == user
  end
end
