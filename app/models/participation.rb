class Participation < ActiveRecord::Base
  belongs_to :user
  belongs_to :challenge
  validates :goal_units, presence: true, numericality: true
  validates :goal_hours, presence: true, numericality: true
  validates :challenge_id, uniqueness: { scope: :user_id }
  has_many :activity_logs

  def stats
    @_stats ||= {
      spent_hours:  s1= activity_logs.sum(:hours_spent) ,
      spent_units:  s2= activity_logs.sum(:units_accomplished) ,
      progress_hours: s1 * 100 / goal_hours,
      progress_units: s2 * 100 / goal_units
    }
  end
end
