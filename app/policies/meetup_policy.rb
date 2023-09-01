class MeetupPolicy < ApplicationPolicy

  class Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.joins(:user_meetups).where(user_meetups: {user_id: user.id})
      end
    end
  end

  def create?
    true
  end

  def delete?
    show?
  end

  def show?
    user.admin? || record.user_meetups.where(user_id: user.id).any?
  end

  def update?
    show?
  end
end
