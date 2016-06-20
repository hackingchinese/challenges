class Resources::Comment < ActiveRecord::Base
  belongs_to :story, class_name: 'Resources::Story'
  belongs_to :user
  has_many :likes, class_name: "Resources::Like", as: :likeable
end
