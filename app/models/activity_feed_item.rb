class ActivityFeedItem < ApplicationRecord
  belongs_to :searchable, polymorphic: true
	belongs_to :challenge
  belongs_to :user
  scope :sorted, -> { order 'created_at desc' }

  private

  def readonly?
    true
  end
end
