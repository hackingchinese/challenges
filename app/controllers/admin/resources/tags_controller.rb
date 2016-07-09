class Admin::Resources::TagsController < ApplicationController
  load_and_authorize_resource :tag, class: ::Resources::Tag

  def index
    @tiers = Resources::Tag.tiers.keys
  end

  def new
  end

  def create
    if @tag.save
      redirect_to [:admin, :resources, :tags], notice: "Tag created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @tag.update(params[:resources_tag])
      redirect_to [:admin, :resources, :tags], notice: "Tag created."
    else
      render :new
    end
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

  def navigation_name
    'resources'
  end
end
