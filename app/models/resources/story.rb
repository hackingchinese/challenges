class Resources::Story < ActiveRecord::Base
  belongs_to :user
  mount_uploader :image, ImageUploader

	has_many :taggings, class_name: "Resources::Tagging", foreign_key: 'story_id', dependent: :destroy
	has_many :tags, through: :taggings
  has_many :likes, class_name: "Resources::Like", as: :likeable, dependent: :destroy, counter_cache: :like_count
  has_many :liked_by, class_name: "User", through: :likes, source: :user
  has_many :comments, class_name: "Resources::Comment", dependent: :destroy, counter_cache: true

  validates :url, presence: true
  validates :title, presence: true
  validates :description, presence: true

  def liked_by?(user)
    return if !user
    likes.where(user_id: user.id).any?
  end

  def notify_new_comment(comment)
    users_to_inform = ([user] + comments.map(&:user)) - [comment.user]
    users_to_inform.each do |user|
      Resources::Mailer.new_comment(comment, user).deliver_now
    end
  end
end
