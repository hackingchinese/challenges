class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable
  mount_uploader :avatar, AvatarUploader

  has_many :participations
  has_many :challenges, through: :participations
  has_many :activity_logs

  after_create :generate_random_image
  def generate_random_image
    image_file = RandomImageGenerator.generate email
    self.avatar = image_file
    self.save! validate: false
  end
end
