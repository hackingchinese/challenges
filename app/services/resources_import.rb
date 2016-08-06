class ResourcesImport
  def self.run
    new.run
  end

  def run
    tags!
    users!
    stories!
    comments!
    likes!
    reset_counters!
    unsubscribers!

    unit_types!
  end

  def unit_types!
    UnitType.where(key: 'pages').first_or_create(
      singular: 'page',
      plural: 'pages',
      verb_present: 'read',
      verb_past: 'read',
    )
    UnitType.where(key: 'haikus').first_or_create(
      singular: 'haiku',
      plural: 'haikus',
      verb_present: 'read',
      verb_past: 'read',
    )
    UnitType.where(key: 'characters').first_or_create(
      singular: 'character',
      plural: 'characters',
      verb_present: 'learn',
      verb_past: 'learned',
    )
    UnitType.where(key: 'movies').first_or_create(
      singular: 'movie',
      plural: 'movies',
      verb_present: 'watch',
      verb_past: 'watched',
    )
    UnitType.where(key: 'tv_episodes').first_or_create(
      singular: 'episode',
      plural: 'episodes',
      verb_present: 'watch',
      verb_past: 'watched',
    )
    UnitType.where(key: 'podcasts').first_or_create(
      singular: 'episode',
      plural: 'episodes',
      verb_present: 'listen to',
      verb_past: 'listened to',
    )
    UnitType.where(key: 'units').first_or_create(
      singular: 'unit',
      plural: 'units',
      verb_present: 'complete',
      verb_past: 'completed',
    )
  end

  def unsubscribers!
    User.find_each do |user|
      user.set_mail_preference
      if user.no_mails
        user.mail_preference.update(challenge_starts_soon: '0', challenge_started: '0', new_resource: '0')
      end
    end
  end

  def reset_counters!
    Resources::Story.connection.execute "ALTER SEQUENCE resources_stories_id_seq RESTART WITH #{Resources::Story.maximum('id') + 1};"
    Resources::Story.connection.execute "ALTER SEQUENCE resources_comments_id_seq RESTART WITH #{Resources::Comment.maximum('id') + 1};"
    Resources::Story.connection.execute "ALTER SEQUENCE resources_tags_id_seq RESTART WITH #{Resources::Tag.maximum('id') + 1};"
    Resources::Story.connection.execute "ALTER SEQUENCE resources_likes_id_seq RESTART WITH #{Resources::Like.maximum('id') + 1};"
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
      @user_mapping[ hash['id'] ] = user.id
    end

  end

  def stories!
    @story_dupes = {}
    yaml('stories').each do |hash|
      story = Resources::Story.where(short_id: hash['short_id']).first_or_initialize
      if story.new_record? and dupe = Resources::Story.where(url: hash['url']).first
        @story_dupes[ hash['id'] ] = dupe.id
        next
      end
      story.created_at = hash['created_at']
      story.id = hash['id']
      story.url = hash['url']
      story.title = hash['title']
      story.description = hash['description'].presence || "."
      story.user_id = @user_mapping[hash['user_id']]
      if story.image.blank? && hash['image_url'].present?
        story.remote_image_url = "http://resources.hackingchinese.com" + hash['image_url']
      end
      story.tag_ids = hash['tag_ids']
      begin
        story.save!
      rescue ActiveRecord::RecordNotUnique
        binding.pry
      rescue ActiveRecord::RecordInvalid
        story.save validate: false
      end
    end

  end

  def comments!
    yaml('comments').each do |hash|
      comment = Resources::Comment.where(id: hash['id']).first_or_initialize
      comment.created_at = hash['created_at']
      comment.story = @story_dupes[hash['story_id']] || Resources::Story.find(hash['story_id'])
      comment.comment = hash['comment']
      comment.id = hash['id']
      comment.user_id = @user_mapping[ hash['user_id'] ]
      comment.save!
    end
  end

  def likes!
    yaml('votes').each do |hash|
      like = Resources::Like.where(id: hash['id']).first_or_initialize
      like.user_id = @user_mapping[ hash['user_id'] ]
      if hash['comment_id']
        like.likeable = Resources::Comment.find(hash['comment_id'])
      else
        like.likeable = Resources::Story.find(@story_dupes[hash['story_id']] ||hash['story_id'])
      end
      like.save!
    end
  end

  def yaml(file)
    YAML.load_file("export/#{file}.yml")
  end
end
