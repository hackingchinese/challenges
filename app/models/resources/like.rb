class Resources::Like < ApplicationRecord
  belongs_to :likeable, polymorphic: true, counter_cache: :like_count
  belongs_to :user
end
