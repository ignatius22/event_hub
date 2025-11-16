class RegistrationPolicy < ApplicationPolicy
  def create?
    user.present? && !user.registered_for?(record.event)
  end

  def destroy?
    user.present? && record.user == user
  end

  class Scope < Scope
    def resolve
      if user&.admin?
        scope.all
      else
        scope.where(user: user)
      end
    end
  end
end
