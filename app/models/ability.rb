class Ability
  include CanCan::Ability

  def initialize(user)
    can :show, Challenge.visible
    can :show, Participation
    return if user.blank?

    challenges_participateble = Challenge.upcoming_or_running.visible
    challenges_loggable = Challenge.running_or_just_ended.visible
    active_participations = Participation.where(challenge_id: challenges_loggable ).where(user_id: user.id)

    if user.role == 'admin'
      can :manage, :all
    else
      can :like, Resources::Story
      if current_user.created_at > 1.day.ago
        can :create, Resources::Comment
      end

      can :read, Challenge, id: Challenge.visible.pluck(:id)
      can :create, ActivityLog, participation_id: active_participations.pluck(:id)
      can :update, :mail_preference

      can :destroy, Participation, user_id: user.id
      can :update, Participation, active_participations do |p|
        p.user_id == user.id
      end

      can [:edit, :update], ActivityLog, participation_id: active_participations.pluck('id')
      cannot [:edit, :update], ActivityLog do |log|
        log.created_at < 1.day.ago
      end
      can :comment, ActivityLog
      can [:like, :toggle_like], ActivityLog
      can :create, ActivityLog::Comment
    end
    cannot :like, ActivityLog, user_id: user.id

    can :enroll, Challenge do |challenge|
      challenges_participateble.include?(challenge) && active_participations.where(challenge_id: challenge.id).none?
    end
    cannot :enroll, Challenge do |c|
      c.to_date < Date.today
    end
    can :create, Participation, challenge_id: challenges_participateble.pluck(:id)
  end
end
