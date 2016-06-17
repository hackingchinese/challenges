class ActivityLog::Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :activity_log
end
