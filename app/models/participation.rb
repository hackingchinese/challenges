class Participation < ActiveRecord::Base
  belongs_to :user
  belongs_to :challenge
  validates :goal_units, numericality: { greater_than: 0 }, if: :goal_unit?
  validates :goal_hours, numericality: { greater_than: 0 }, if: :goal_time?
  validates :challenge_id, uniqueness: { scope: :user_id }
  has_many :activity_logs

  scope :leaderboard, -> {
    where('score is not null').order('score desc')
  }

  delegate :goal_unit?, :goal_time?, :unit_detail, to: :challenge

  def score
    activity_logs.sum(:score)
  end

  def goal
    if goal_unit?
      unit_detail[:goal].gsub('#{count}', goal_units.to_s)
    else
      "#{goal_hours}h"
    end
  end

  def challenge_goal
    if goal_unit?
      goal_units
    else
      goal_hours
    end
  end

  def activity_column
    if goal_unit?
      :units_accomplished
    else
      :hours_spent
    end
  end

  def goal_progress
    return 0 if challenge_goal == 0
    activity_logs.sum(activity_column) * 100 / challenge_goal rescue 0
  end

  def rank
    sql = <<-SQL
    WITH board as (
      SELECT participations.id, ROW_NUMBER() OVER(ORDER BY score desc) as position
      FROM participations
      WHERE participations.challenge_id = #{challenge_id} AND
            score is not null
    )
    SELECT position FROM board s WHERE s.id = #{id};
    SQL
    value = Participation.connection.execute(sql).first
    if value
      value['position'].to_i
    end
  end

  def update_score
    self.update_column :score,  activity_logs.sum(:score)
  end
end
