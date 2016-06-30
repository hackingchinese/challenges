class Resources::Story < ApplicationRecord
  belongs_to :user
  mount_uploader :image, ImageUploader
  include PgSearch
  multisearchable :against => [:title, :description, :url, :tag_list]

	has_many :taggings, class_name: "Resources::Tagging", foreign_key: 'story_id', dependent: :destroy
	has_many :tags, through: :taggings
  has_many :likes, class_name: "Resources::Like", as: :likeable, dependent: :destroy, counter_cache: :like_count
  has_many :liked_by, class_name: "User", through: :likes, source: :user
  has_many :comments, class_name: "Resources::Comment", dependent: :destroy, counter_cache: true

  validates :url, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validate :check_tags

  def liked_by?(user)
    return if !user
    likes.where(user_id: user.id).any?
  end

  def tag_list
    tags.pluck(:name)
  end

  before_save :set_domain_name, if: :url_changed?

  def to_param
    "#{id}-#{title.to_url}"
  end

  def notify_new_comment(comment)
    users_to_inform = ([user] + comments.map(&:user)) - [comment.user]
    users_to_inform.each do |user|
      Resources::Mailer.new_comment(comment, user).deliver_now
    end
  end

  private

  def set_domain_name
    uri = URI.parse(self.url)
    self.domain_name = uri.host.remove('www.','')
  rescue URI::InvalidURIError
  end

  def check_tags
    tags = self.taggings.map{|i| i.tag }
    if tags.none?{|i| i.level?} || tags.none?{|i| i.topic?}
      errors.add :tags, 'Please select at least one tag from the proficiency and one from the skill list'
    end
  end
end
