ActiveParams.config do |config|
  config.scope   = proc { |controller|
    "#{controller.request.method} #{controller.params[:controller]}/#{controller.action_name}"
  }
end
