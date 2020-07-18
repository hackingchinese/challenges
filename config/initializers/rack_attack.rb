Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

FILTER_REGEX = %r{/etc/passwd|/proc/self|/etc/hosts/| FROM | INFORMATION_SCHEMA|\.\./\.\.| order by |a=0|UNION ALL|ORDER BY|INFORMATION_SCHEMA|PG_SLEEP|UNION SELECT CHAR|AnD sLeep|UNION|CHAR}i
Rack::Attack.blocklist('fail2ban pentesters') do |req|
  Rack::Attack::Fail2Ban.filter("pentesters-#{req.ip}", maxretry: 3, findtime: 10.minutes, bantime: 60.minutes) do
    qs = CGI.unescape(req.query_string)
    qs =~ FILTER_REGEX ||
      req.path.include?('/etc/passwd') ||
      req.path.include?('setup.php') ||
      req.path.include?('phpMyAdmin') ||
      req.path.include?('xmlrpc.php') ||
      req.path.include?('wp-admin') ||
      req.path.include?('wp-login')
  end
end
