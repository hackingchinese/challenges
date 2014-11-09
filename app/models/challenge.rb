class Challenge < ActiveRecord::Base
  enum goal_type: [ :goal_time, :goal_unit ]

  has_many :participations
  has_many :users, through: :participations
  has_many :activity_logs, through: :participations

  scope :visible, -> {where visible: true }
  scope :running, -> { where 'from_date <= :date and to_date >= :date', date: Date.today}
  scope :upcoming_or_running, -> {
    where 'to_date >= :date', date: Date.today
  }
  scope :upcoming, -> {
    where('from_date > :date', date: Date.today)
  }
  scope :running_or_just_ended, -> {
    where 'from_date <= :date and :yesterday <= to_date',
      date: Date.today,
      yesterday: 1.day.ago.to_date
  }
  scope :sorted, -> { order(:from_date) }

  validates :title, presence: true
  validates :from_date, presence: true
  validates :to_date, presence: true
  validates :unit, presence: true, if: :goal_unit?


  def running?
    from_date and from_date <= Date.today and Date.today <=to_date
  end

  def running_or_just_ended?
    running? or to_date == Date.yesterday
  end

  def to_param
    "#{id}-#{title.to_url}"
  end

  def duration_days
    (to_date - from_date).to_i
  end

  def leaderboard
    participations.leaderboard
  end

  def time_progress
    [100 - days_left * 100 / duration_days, 100].min
  end

  def unit_detail
    I18n.t("units.#{unit}")
  end

  def upcoming?
    from_date >= Date.today
  end

  def days_left
    (to_date - Date.today).to_i
  end

  def self.model_name
    if self == Challenge
      super
    else
      Challenge.model_name
    end
  end

  def to_partial_path
    'challenges/challenge'
  end

end
