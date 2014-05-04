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
      can :read, Challenge, id: Challenge.visible
      can :create, Participation, challenge_id: challenges
      can :manage, Participation, user_id: user.id
      can :new, ActivityLog
      can :create, ActivityLog do |log|
        user.participations.where(challenge_id: challenges).pluck('participations.id').include?(log.participation.id) && log.user_id == user.id && log.challenge.running?
      end
      can :manage, Participation, user_id: user.id, challenge_id: Challenge.upcomming_or_running.visible
      cannot [:edit, :update], ActivityLog do |log|
        log.created_at < 1.day.ago
      end
    end
  end
end
