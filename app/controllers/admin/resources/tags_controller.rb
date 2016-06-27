class Admin::Resources::TagsController < InheritedResources::Base
  load_and_authorize_resource :tag, class: ::Resources::Tag
  defaults :resource_class => ::Resources::Tag, :collection_name => 'tags', :instance_name => 'tag'
  actions :all, except: [:show]

  def index
    @tiers = Resources::Tag.tiers.keys
  end

  def resort
    tags = Resources::Tag.send(params['tier'])
    sort_order = params[:ids].map(&:to_i)
    new_order = tags.sort_by{|tag| sort_order.index(tag.id) || 99 }
    new_order.each_with_index do |tag, i|
      tag.update weight: i
    end
    Rails.cache.delete('tag_sort_order')
    render nothing: true
  end

  protected

  def permitted_params
    params.permit!
  end

  def navigation_name
    'resources'
  end
end
