require "spec_helper"
describe Ability do
  let(:user) { Fabricate :user }
  let(:ability) { Ability.new(user) }
  delegate :can?, :cannot?, to: :ability
  def can!(*args)
    expect(can?(*args)).to eql true
  end
  def cannot!(*args)
    expect(cannot?(*args)).to eql true
  end

  describe 'Activity Log' do
    let(:participation) { Fabricate :participation }
    let(:user) { participation.user }
    let(:other_user) { Fabricate :generated_user }

    specify 'can create own' do
      expect(can?(:create, ActivityLog.new(participation_id: participation.id))).to eql true
    end

    specify 'cannot create for other' do
      ability = Ability.new(other_user)
      expect(
        ability.cannot?(:create, ActivityLog.new(participation_id: participation.id))
      ).to eql true
    end

    specify 'cannot create upcoming challenge' do
      participation.challenge.update! from_date: 7.days.from_now, to_date: 27.days.from_now
      expect(
        cannot?(:create, ActivityLog.new(participation_id: participation.id))
      ).to eql true
    end
    specify 'cannot create for old challenge' do
      participation.challenge.update! from_date:  27.days.ago, to_date: 7.days.ago
      expect(cannot?(:create, ActivityLog.new(participation_id: participation.id))).to eql true
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
