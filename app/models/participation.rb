class Participation < ActiveRecord::Base
  belongs_to :user
  belongs_to :challenge
  validates :goal_units, presence: true, numericality: true
  validates :goal_hours, presence: true, numericality: true
  validates :challenge_id, uniqueness: { scope: :user_id }
  has_many :activity_logs
end
