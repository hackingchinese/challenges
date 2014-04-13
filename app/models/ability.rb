class Ability
  include CanCan::Ability

  def initialize(user)
    if user.role == 'admin'
      can :manage, :all
    else
      can :read, Challenge
      can :create, Participation
      can :manage, Participation, user_id: user.id
      can :create, ActivityLog
      can :manage, Participation, user_id: user.id
    end
  end
end
