set :application, 'challenge'
set :repo_url, 'git@github.com:hackingchinese/challenges.git'
set :rvm_ruby_version, '2.1.1'
set :rvm_type, :user


# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, '/var/www/challenges.hackingchinese.com/'
set :scm, :git

set :format, :pretty
set :pty, true
# set :log_level, :info

set :linked_files, %w{config/database.yml config/secrets.yml config/email.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/uploads}

set :keep_releases, 2

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  # after :restart, :clear_cache do
  #   on roles(:web), in: :groups, limit: 3, wait: 10 do
  #     within release_path do
  #       execute :rake, 'cache:clear'
  #     end
  #   end
  # end

  after :finishing, 'deploy:cleanup'
  # after 'deploy:starting',  'sidekiq:quiet'

  # after 'reverted',  'sidekiq:start'

  # after 'published', 'sidekiq:restart'
  after 'published', :update_crontab
  after 'restart', :ping_restart
end

desc 'ping server for passenger restart'
task :ping_restart do
  run_locally do
    execute 'curl --silent http://challenges.hackingchinese.com'
  end
end


desc "Update crontab with whenever"
task :update_crontab do
  on roles(:all) do
    within release_path do
      execute :bundle, :exec, "whenever --update-crontab #{fetch(:application)}"
    end
  end
end

namespace :rails do
  task :tail, :file do |t, args|
    file = args[:file] || 'production'
    on roles(:app) do
      execute "tail -f #{shared_path}/log/#{file}.log"
    end
  end

  desc 'Access a remote bash console'
  task bash: ['deploy:set_rails_env'] do
    app_server = roles(:app).first

    # RVM support
    if rvm_loaded?
      Rake::Task['rvm:hook'].invoke
      set :rvm_map_bins, ((fetch(:rvm_map_bins) || []) + ['rails'])
    end

    # command = []
    # command << "#{fetch(:rvm_path)}/bin/rvm #{fetch(:rvm_ruby_version)} do" if rvm_loaded?
    # command << "bundle exec" if bundler_loaded?
    # command << "rails console #{fetch(:rails_env)}"
    command = 'bash'

    exec %Q(ssh #{app_server.user}@#{app_server.hostname} -p #{app_server.port || 22} -t "export RAILS_ENV=#{fetch(:rails_env)} && cd #{current_path} && #{command} ")
  end
end
