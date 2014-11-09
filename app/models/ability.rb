class Ability
  include CanCan::Ability

  def initialize(user)
    can :show, Challenge.visible
    can :show, Participation
    return if user.blank?
    if user.role == 'admin'
      can :manage, :all
    else

      can :read, Challenge, id: Challenge.visible.pluck(:id)
      challenges_loggable = Challenge.running_or_just_ended.visible
      active_participations = Participation.where(challenge_id: challenges_loggable ).where(user_id: user.id)
      challenges_participateble = Challenge.upcoming_or_running.visible
      can :create, Participation, challenge_id: challenges_participateble.pluck(:id)
      can :create, ActivityLog, participation_id: active_participations.pluck(:id)

      can :destroy, Participation, user_id: user.id
      can :update, Participation, active_participations do |p|
        p.created_at > 7.days.ago && p.user_id == user.id
      end

      cannot [:edit, :update], ActivityLog do |log|
        log.created_at < 1.day.ago
      end
    end
  end
end
