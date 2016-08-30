class ResourcesFilter
  attr_reader :params, :selected_tag_ids
  def initialize(params)
    @params = params

    @tags = Resources::Tag.all
    @selected_tags_per_tier = {}
    Resources::Tag.tiers.each do |tier, _|
      @selected_tags_per_tier[tier] = (params[tier] || "").split("+").map{|n| @tags.find{|t| t.name == n } }.compact
    end

    @selected_tag_ids = @selected_tags_per_tier.values.flatten.map(&:id)
    @link_map = @selected_tags_per_tier.transform_values{|t| t.map(&:name) }
  end

  def tag_active?(tag)
    @selected_tag_ids.include?(tag.id)
  end

  def enable_filter_path(tag)
    options = @link_map.deep_dup
    options[ tag.tier ] << tag.name
    search_path(options)
  end

  def disable_filter_path(tag)
    options = @link_map.deep_dup
    options[ tag.tier ].delete tag.name
    search_path(options)
  end

  def search_path(options)
    options.delete_if{|k,v| v.size == 0 }
    out = options.transform_keys{|k| k.to_sym }.transform_values{|value| value.sort.join("+") }
    ApplicationController._routes.url_for( out.merge(controller: 'resources/stories', action: 'index', only_path: true))
  end

  def tag_count_before_filter(tag)
    story_sql(extra_tiers: { tag.tier => [ tag ]}).count
  end

  def story_sql(extra_tiers: {})
    sql = Resources::Story.all
    Resources::Tag.tiers.each do |tier,_|
      tg = (@selected_tags_per_tier[tier] || []) + (extra_tiers[tier] || [])
      if tg.any?
        sql = sql.where(id: Resources::Tagging.where(tag_id: tg.compact.map(&:id)).select(:story_id) )
      end
    end
    sql
  end

  def stories
    return @stories if @stories
    base =  story_sql.
      includes(:tags, :user)

    if @selected_tag_ids.any?
      base = base.order('resources_stories.like_count desc, resources_stories.created_at desc')
    else
      base = base.order('resources_stories.created_at desc')
    end
    @stories = base.page(params[:page]).per(54)
  end
end
