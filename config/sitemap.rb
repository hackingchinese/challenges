# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://challenges.hackingchinese.com"
SitemapGenerator::Sitemap.public_path = 'public/uploads'
SitemapGenerator::Sitemap.create do
  add '/resources', priority: 1.0

  Resources::Story.find_each do |story|
    add resources_story_path(story), lastmod: story.updated_at
  end
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
end
