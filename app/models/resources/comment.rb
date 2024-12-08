class Resources::Comment < ApplicationRecord
  belongs_to :story, class_name: 'Resources::Story', counter_cache: true
  belongs_to :user
  has_many :likes, class_name: "Resources::Like", as: :likeable

  validates :comment, presence: true
  include PgSearch::Model
  multisearchable :against => [:comment]
end
