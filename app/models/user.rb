class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :lockable
  mount_uploader :avatar, AvatarUploader

  has_many :participations, dependent: :destroy
  has_many :challenges, through: :participations
  has_many :activity_logs, dependent: :destroy
  has_many :account_connections, dependent: :destroy
  has_many :stories, class_name: 'Resources::Story', dependent: :nullify
  has_one :mail_preference, dependent: :destroy

  has_many :likes, class_name: 'Resources::Like', dependent: :nullify

  validates :name, presence: true, uniqueness: true
  validates :privacy, acceptance: true, on: :create
  after_create :set_mail_preference
  after_create :generate_random_image

  scope :with_email, -> { where('no_mails = ?', false).where('email not like ?', '%@changeme.com') }

  def fake_email?
    !email || email[/@changeme/]
  end

  def set_mail_preference
    mail_preference || create_mail_preference
  end

  def admin?
    role == 'admin'
  end

  def generate_random_image
    image_file = RandomImageGenerator.generate email
    self.avatar = image_file
    save! validate: false
  end
end
