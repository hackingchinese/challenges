class Admin::Resources::TagsController < InheritedResources::Base
  load_and_authorize_resource :tag, class: ::Resources::Tag
  defaults :resource_class => ::Resources::Tag, :collection_name => 'tags', :instance_name => 'tag'
  actions :all, except: [:show]

  def index
    @tiers = Resources::Tag.tiers.keys
  end

  protected

  def permitted_params
    params.permit!
  end

  def navigation_name
    'resources'
  end
end
