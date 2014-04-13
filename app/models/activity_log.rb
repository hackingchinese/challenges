class ActivityLog < ActiveRecord::Base
  belongs_to :user
  belongs_to :participation
end
