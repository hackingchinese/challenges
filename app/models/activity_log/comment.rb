class ActivityLog::Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :activity_log
  scope :sorted, -> { order :created_at }

  validates :text, presence: true
end
