class Resources::Story < ActiveRecord::Base
  belongs_to :user
  mount_uploader :image, ImageUploader

	has_many :taggings, class_name: "Resources::Tagging", foreign_key: 'story_id', dependent: :destroy
	has_many :tags, through: :taggings
  has_many :likes, class_name: "Resources::Like", as: :likeable
end
