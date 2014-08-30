class Ability
  include CanCan::Ability

  def initialize(user)
    can :show, Challenge.visible
    can :show, Participation
    return if user.blank?
    if user.role == 'admin'
      can :manage, :all
    else
      challenges = Challenge.upcoming_or_running.visible
      can :read, Challenge, id: Challenge.visible.pluck(:id)

      active_participations = Participation.where(challenge_id: Challenge.running).where(user_id: user.id)
      can :create, Participation, challenge_id: challenges.pluck(:id)
      can :create, ActivityLog, participation_id: active_participations.pluck(:id)

      can :destroy, Participation, user_id: user.id
      can :update, Participation, active_participations do |p|
        p.created_at > 7.days.ago
      end

      cannot [:edit, :update], ActivityLog do |log|
        log.created_at < 1.day.ago
      end
    end
  end
end
