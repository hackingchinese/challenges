class AccountConnectionsController < ApplicationController

  def omniauth
    data = request.env['omniauth.auth']
    link = AccountConnection.where(uid: data.uid, provider: data.provider).first_or_initialize
    link.user ||= current_user
    link.token = data.credentials.slice('token','secret').values.join(':')
    if link.user.nil?
      user = link.build_user

      original_name = data.info['nickname'] || data.info['name']
      name = original_name
      100.times do |i|
        if User.where(name: name).count == 0
          break
        end
        name = original_name + (i + 2).to_s
      end
      user.name = name
      user.email = data['info']['email'] || name + '@changeme.com'
      if !user.save
        user.email = "#{name}@changeme.com"
        user.save
      end

      user.remote_avatar_url = data.info['image']
      user.save validate: false
      link.save
    end
    sign_in link.user
    redirect_to '/', notice: 'Log in successful.'
  end
end
