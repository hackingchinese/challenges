class ActivityLog < ActiveRecord::Base
  belongs_to :user
  belongs_to :participation
  validates_presence_of :user_id, :participation_id
  validate :units_or_hours

  def units_or_hours
    if units_accomplished.blank? and hours_spent.blank?
      errors.add(:base, 'You must either report time spent and/or units accomplished')
    end
  end
end
