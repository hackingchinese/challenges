# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path
Rails.application.config.tap do |config|
  config.assets.paths << Rails.root.join('vendor/hc-theme/design/scss').to_s
  config.assets.paths << Rails.root.join('vendor/hc-theme/wp-content/themes/hc-2015/fonts').to_s
  config.assets.precompile += %w( icomoon.eot icomoon.svg icomoon.ttf icomoon.woff)
  config.assets.precompile += %w( admin.js )
end

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
