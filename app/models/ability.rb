class Ability
  include CanCan::Ability

  def initialize(user)
    if user.blank?
      can :show, Challenge.visible
      can :show, Participation
      return
    end
    if user.role == 'admin'
      can :manage, :all
    else
      challenges = Challenge.upcomming_or_running.visible
      can :read, Challenge, id: Challenge.visible
      can :create, Participation, challenge_id: challenges
      can :manage, Participation, user_id: user.id
      can :create, ActivityLog,
        participation_id: user.participations.where(challenge_id: challenges),
        user_id: user.id
      can :manage, Participation, user_id: user.id, challenge_id: Challenge.upcomming_or_running.visible
      cannot [:edit, :update], ActivityLog do |log|
        log.created_at < 1.day.ago
      end
    end
  end
end
