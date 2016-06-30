class Resources::Tagging < ApplicationRecord
  belongs_to :tag, class_name: 'Resources::Tag'
  belongs_to :story, class_name: 'Resources::Story'
end
