class ResourcesImport
  def self.run
    new.run
  end

  def run
    tags!
    users!
    stories!
    comments!
    # likes!
  end

  def tags!
    tiers = Resources::Tag.tiers.map(&:reverse).to_h
    yaml("tags").each do |hash|
      Resources::Tag.where(id: hash['id']).first_or_create(
        id:        hash['id'],
        name:      hash['tag'],
        important: hash['important'],
        tier:      tiers[hash['tier']]
      )
    end
  end

  def users!
    @user_mapping = {}
    yaml('users').each do |hash|
      user = User.where(imported_from_resources_id: hash['id']).first ||
        User.where(email: hash['email']).first ||
        User.where(name: hash['username']).first || User.new
      user.email = hash['email'] if user.email.blank?
      user.name = hash['username'] if user.name.blank?
      user.encrypted_password = hash['password_digest'] if user.encrypted_password.blank?
      user.about = hash['about'] if user.about.blank?
      user.imported_from_resources_id = hash['id']

      def user.password_required?
        false
      end
      user.save!
      @user_mapping[hash['id']] = user.id
    end

  end

  def stories!
    yaml('stories').each do |hash|
      story = Resources::Story.where(short_id: hash['short_id']).first_or_initialize
      story.created_at = hash['created_at']
      story.id = hash['id']
      story.url = hash['url']
      story.title = hash['title']
      story.description = hash['description']
      story.user_id = @user_mapping[hash['id']]
      if story.image.blank? && hash['image_url'].present?
        story.remote_image_url = "http://resources.hackingchinese.com" + hash['image_url']
      end
      story.tag_ids = hash['tag_ids']
      begin
        story.save
      rescue ActiveRecord::RecordNotUnique
        binding.pry
      end
    end

  end

  def comments!
    yaml('comments').each do |hash|
      comment = Resources::Comment.where(id: hash['id']).first_or_initialize
      comment.created_at = hash['created_at']
      comment.story = Resources::Story.find(hash['story_id'])
      comment.comment = hash['comment']
      comment.id = hash['id']
      comment.user_id = @user_mapping[ hash['user_id'] ]
      comment.save!
    end
  end

  def yaml(file)
    YAML.load_file("export/#{file}.yml")
  end
end
