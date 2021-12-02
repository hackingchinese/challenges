class ResourcesFilter
  attr_reader :params, :selected_tag_ids
  def initialize(params)
    @params = params

    @tags = Resources::Tag.all
    @selected_tags_per_tier = {}
    Resources::Tag.tiers.each do |tier, _|
      @selected_tags_per_tier[tier] = (params[tier] || "").split("+").map { |n| @tags.find { |t| t.name == n } }.compact
    end

    @selected_tag_ids = @selected_tags_per_tier.values.flatten.map(&:id)
    @link_map = @selected_tags_per_tier.transform_values { |t| t.map(&:name) }
    @sort = params[:sort]
  end

  def sort
    ['newest', 'popular'].include?(@sort) ? @sort : 'newest'
  end

  def tag_active?(tag)
    @selected_tag_ids.include?(tag.id)
  end

  def enable_filter_path(tag)
    options = @link_map.deep_dup
    options[tag.tier] << tag.name
    search_path(options)
  end

  def current_path
    search_path(@link_map.deep_dup)
  end

  def disable_filter_path(tag)
    options = @link_map.deep_dup
    options[tag.tier].delete tag.name
    search_path(options)
  end

  def sort_path(sort)
    search_path(@link_map.deep_dup, sort: sort)
  end

  def search_path(options, extra = {})
    options.delete_if { |_, v| v.size == 0 }
    out = options.transform_keys { |k| k.to_sym }.transform_values { |value| value.sort.join("+") }
    ApplicationController._routes.url_for(out.merge(controller: 'resources/stories', action: 'index', only_path: true).merge(extra))
  end

  def tag_count_before_filter(tag)
    if @selected_tags_per_tier.values.flatten.count > 6
      # security measure
      return -1
    end

    story_sql(extra_tiers: { tag.tier => [tag] }).count
  end

  def story_sql(extra_tiers: {})
    sql = Resources::Story.all
    Resources::Tag.tiers.each do |tier, _|
      tg = (@selected_tags_per_tier[tier] || []) + (extra_tiers[tier] || [])
      if tg.any?
        sql = sql.where(id: Resources::Tagging.where(tag_id: tg.compact.map(&:id)).select(:story_id))
      end
    end
    sql
  end

  def title
    if @selected_tag_ids == []
      "all topics"
    else
      @link_map.values.flatten.sort.to_sentence
    end
  end

  def stories
    return @stories if @stories
    base =  story_sql.
      includes(:tags, :user)

    base = if @selected_tag_ids.any? || sort == 'popular'
             base.order('resources_stories.like_count desc, resources_stories.created_at desc')
           else
             base.order('resources_stories.created_at desc')
           end
    @stories = base.page(params[:page]).per(54)
  end
end
