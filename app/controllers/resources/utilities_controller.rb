class Resources::UtilitiesController < ApplicationController
  def fetch_url
    authorize! :create, Resources::Story
    url = params[:url]
    fetcher = StoryFetcher.new(url, params[:id])
    if fetcher.run()
      render json: {
        title: fetcher.title,
        description: fetcher.description,
        image_cache: fetcher.image_cache,
      }
    else
      render json: {
        error: fetcher.error
      }, status: 422
    end

  end

  def markdown_preview
    authorize! :create, Resources::Story
  end
end
