class Resources::Like < ActiveRecord::Base
  belongs_to :likeable, polymorphic: true, counter_cache: :like_count
  belongs_to :user
end
