class Ability
  include CanCan::Ability

  def initialize(user)
    can :show, Challenge.visible
    can :show, Participation
    return if user.blank?
    if user.role == 'admin'
      can :manage, :all
    else
      challenges = Challenge.upcomming_or_running.visible
      can :read, Challenge, id: Challenge.visible.pluck(:id)
      can :create, Participation, challenge_id: challenges.pluck(:id)
      can :manage, Participation, user_id: user.id
      can :create, ActivityLog, participation_id: Participation.where(challenge_id: Challenge.running, user_id: user.id).pluck(:id)
      can :manage, Participation, user_id: user.id
      cannot [:edit, :update], ActivityLog do |log|
        log.created_at < 1.day.ago
      end
    end
  end
end
