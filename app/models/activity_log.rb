class ActivityLog < ActiveRecord::Base

  belongs_to :user
  belongs_to :participation
  has_one :challenge, through: :participation
  has_many :likes, class_name: 'ActivityLog::Like', dependent: :destroy
  has_many :liked_by, class_name: 'User', through: :likes, source: :user
  has_many :comments, class_name: "ActivityLog::Comment", dependent: :destroy

  validates_presence_of :user_id, :participation_id
  validates :units_accomplished, numericality: { greater_than: 0 }, if: ->(r){ r.challenge.goal_unit? }
  validates :minutes, numericality: { greater_than: 0 }, if: ->(r){ r.challenge.goal_time? }
  validate :date_valid

  before_save :set_score
  after_save :update_participation_score

  def date_valid
    if date_changed? and date.present?

      if date < 7.days.ago.to_date or date > Time.zone.now.to_date
        errors.add :date, "The date can't be less than a week ago nor in the future"
      end
      if date < challenge.from_date or date > challenge.to_date
        errors.add :date, "The date is outside of the challenge's timeframe"
      end
    end
  end

  def update_participation_score
    participation.update_score
  end

  def set_score
    self.score = self.send(participation.activity_column)
    # TODO Extensive/Intensive

    self.date ||= Time.zone.now.to_date
  end

  def minutes=(value)
    if value.present?
      self.hours_spent = (value.to_i / 60.to_f).round(2)
    else
      self.hours_spent = nil
    end
    super
  end

  def share_text
    if challenge.goal_time?
      I18n.t('participations.show.twitter_share_text_time', count: minutes)
    else
      I18n.t('participations.show.twitter_share_text', past: participation.unit_detail[:past].gsub('#{count}', units_accomplished.to_s))
    end
  end
end
