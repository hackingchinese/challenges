class ActivityLog < ActiveRecord::Base
  belongs_to :user
  belongs_to :participation
  has_one :challenge, through: :participation
  validates_presence_of :user_id, :participation_id
  validates :units_accomplished, numericality: { greater_than: 0 }, if: ->(r){r.challenge.goal_unit? }
  validates :minutes, numericality: { greater_than: 0 }, if: ->(r){r.challenge.goal_time? }

  before_save :set_score
  after_save :update_participation_score

  def update_participation_score
    participation.update_score
  end

  def set_score
    self.score = self.send(participation.activity_column)
    # TODO Extensive/Intensive
  end

  def minutes=(value)
    if value.present?
      self.hours_spent = (value.to_i / 60.to_f).round(2)
    else
      self.hours_spent = nil
    end
    super
  end

end
