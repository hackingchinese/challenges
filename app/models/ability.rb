class Ability
  include CanCan::Ability

  def initialize(user)
    return if user.blank?
    if user.role == 'admin'
      can :manage, :all
    else
      can :read, Challenge, id: Challenge.visible
      can :create, Participation, challenge_id: Challenge.running
      can :manage, Participation, user_id: user.id
      can :create, ActivityLog, participation_id: user.participation_ids, user_id: user.id
      can :manage, Participation, user_id: user.id, challenge_id: Challenge.running.visible
    end
  end
end
