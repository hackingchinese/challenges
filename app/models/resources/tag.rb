class Resources::Tag < ActiveRecord::Base
  enum tier: [:level, :topic, :type, :extra ]

  has_many :taggings, class_name: "Resources::Tagging", foreign_key: "tag_id", dependent: :destroy
  has_many :stories, through: :taggings
end
