class Resources::Tag < ActiveRecord::Base
  enum tier: [:level, :topic, :type, :extra ]

  has_many :taggings, class_name: "Resources::Tagging", foreign_key: "tag_id", dependent: :destroy
  has_many :stories, through: :taggings
  scope :sorted, -> { order 'weight, name' }

  def self.tag_sort_order
    Rails.cache.fetch('tag_sort_order', expires_in: 1.hour) do
      Resources::Tag.order('tier, weight, name').pluck :id
    end
  end
end
