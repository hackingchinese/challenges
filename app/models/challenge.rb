class Challenge < ActiveRecord::Base
  validates :title, presence: true
  validates :from_date, presence: true
  validates :to_date, presence: true

  scope :visible, -> {where visible: true }
  scope :running, -> { where 'from_date <= :date and to_date >= :date', date: Date.today}

  has_many :participations
  has_many :users, through: :participations

  def running?
    from_date <= Date.today and Date.today <=to_date
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
