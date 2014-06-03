require "spec_helper"
describe Ability do
  let(:user) { Fabricate :user }
  let(:ability) { Ability.new(user) }
  delegate :can?, :cannot?, to: :ability
  def can!(*args)
    expect(can?(*args)).to be_true
  end
  def cannot!(*args)
    expect(cannot?(*args)).to be_true
  end
  describe 'Activity Log' do

    let(:participation) { Fabricate :participation }
    let(:user) { participation.user }
    let(:other_user) { Fabricate :generated_user }


    specify 'can create own' do
      can?(:create, ActivityLog.new(participation_id: participation.id)).should be_true
    end

    specify 'cannot create for other' do
      ability = Ability.new(other_user)
      ability.cannot?(:create, ActivityLog.new(participation_id: participation.id)).should be_true
    end

    specify 'cannot create upcoming challenge' do
      participation.challenge.update_attributes! from_date: 7.days.from_now, to_date: 27.days.from_now
      cannot?(:create, ActivityLog.new(participation_id: participation.id)).should be_true
    end
    specify 'cannot create for old challenge' do
      participation.challenge.update_attributes! from_date:  27.days.ago, to_date: 7.days.ago
      cannot?(:create, ActivityLog.new(participation_id: participation.id)).should be_true
    end
  end

  specify 'Can participate in upcoming challenges' do
    challenge = Fabricate :challenge, from_date: 7.days.from_now, to_date: 27.days.from_now
    can! :create, Participation.new(challenge_id: challenge.id)
  end

  specify 'Cannot participate in old challenges' do
    challenge = Fabricate :challenge, from_date: 27.days.ago, to_date: 7.days.ago
    cannot! :create, Participation.new(challenge_id: challenge.id)
  end

end
