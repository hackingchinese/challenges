if Rails.env.production?
  Rack::Attack.cache.store = ActiveSupport::Cache::RedisCacheStore.new(namespace: "hc.")
else
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
end
Rack::Attack.cache.store = ActiveSupport::Cache::RedisCacheStore.new(namespace: "hc.")

FILTER_REGEX = %r{/etc/passwd|/proc/self|/etc/hosts/| FROM | INFORMATION_SCHEMA|\.\./\.\.| order by |a=0|UNION ALL|ORDER BY|INFORMATION_SCHEMA|PG_SLEEP|UNION SELECT CHAR|AnD sLeep|UNION}i

BAD_UA = /bytespider|semrushbot|mj12bot/i

Rack::Attack.blocklist('block bad UA logins') do |req|
  req.user_agent.to_s[BAD_UA]
end

Rack::Attack.blocklist('fail2ban pentesters') do |req|
  Rack::Attack::Fail2Ban.filter("pentesters-#{req.ip}", maxretry: 3, findtime: 10.minutes, bantime: 60.minutes) do
    qs = CGI.unescape(req.query_string)
    qs =~ FILTER_REGEX ||
      req.path.include?('/etc/passwd') ||
      req.path.include?('setup.php') ||
      req.path.include?('phpMyAdmin') ||
      req.path.include?('xmlrpc.php') ||
      req.path.include?('wp-admin') ||
      req.path.include?('wp-login') ||
      !CGI.unescape(req.path).valid_encoding?
  end
end

Rack::Attack.throttle("requests by ip on ", limit: 2, period: 120) do |request|
  logged_in = request.env['rack.session']['warden.user.user.key']

  if request.path.starts_with?('/resources') && request.path.length > 70 && !logged_in
    request.ip
  end
end

Rack::Attack.throttle("registrations", limit: 5, period: 15.minutes) do |request|
  if request.post? && request.path.starts_with?('/users')
    request.ip
  end
end

Rack::Attack.throttle("throttle_baidu_bot", limit: 30, period: 602) do |request|
  if request.path.starts_with?('/resources') && request.path.length > 70 && request.user_agent.to_s['Baiduspider']
    request.ip.split('.')[0..1].join('.')
  end
end
Rack::Attack.enabled = Rails.env.production?


Rack::Attack.blocklist('block bad UA logins for search') do |req|
  req.user_agent.to_s[%r{trident|firefox/\d\d?\.|android [12][^\d]|iphone OS \d_}i]
end
