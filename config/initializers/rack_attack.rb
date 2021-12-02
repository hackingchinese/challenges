if Rails.env.production?
  Rack::Attack.cache.store = ActiveSupport::Cache::RedisCacheStore.new(namespace: "hc.")
else
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
end
Rack::Attack.cache.store = ActiveSupport::Cache::RedisCacheStore.new(namespace: "hc.")

FILTER_REGEX = %r{/etc/passwd|/proc/self|/etc/hosts/| FROM | INFORMATION_SCHEMA|\.\./\.\.| order by |a=0|UNION ALL|ORDER BY|INFORMATION_SCHEMA|PG_SLEEP|UNION SELECT CHAR|AnD sLeep|UNION}i

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

Rack::Attack.throttle("requests by ip on ", limit: 30, period: 120) do |request|
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
