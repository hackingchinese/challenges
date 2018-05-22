require 'spec_helper'

describe AccountConnectionsController do
  before(:each) {
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:twitter] = nil
    OmniAuth.config.mock_auth[:facebook] = nil
  }

  specify 'Twitter' do
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(
      "provider" => "twitter",
      "uid" => "98188244",
      "info" => {
        "nickname" => "stefanwienert",
        "name" => "Stefan Wienert",
        "location" => "Dresden, Germany",
        "image" => "http://pbs.twimg.com/profile_images/438813559045095424/e6QwEVQP_normal.jpeg",
        "description" => "Lead developer at @pludoni working in Dresden, living in Frankfurt. #Ruby, #RubyOnRails, #vim, #China",
        "urls" => {
          "Website" => "http://t.co/F1UG9don0R",
          "Twitter" => "https://twitter.com/stefanwienert"
        }
      },
      "credentials" => {
        "token" => "98188244-0123123123",
        "secret" => "123123123123123123123"
      }
    )
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]

    get :omniauth, params: { provider: :twitter }
    expect(response).to be_redirect
    expect(AccountConnection.count).to eql 1
    AccountConnection.first.tap do |ac|
      expect(ac.uid).to eql '98188244'
      expect(ac.user).to be_present
      expect(ac.user.name).to eql 'stefanwienert'
    end

    expect(controller.current_user).to be_present

    # Re login
    get :omniauth, params: { provider: :twitter }, session: {}
    expect(response).to be_redirect
    expect(AccountConnection.count).to eql 1
    expect(controller.current_user).to be_present
  end

  specify 'Facebook with special chars' do
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new(
      "provider" => "facebook",
      "uid" => "100001844680649",
      "info" => {
        "nickname" => "Hzg Castaño",
        "email" => "stwienert@gmail.com",
        "name" => "Stefan Wienert",
        "first_name" => "Stefan",
        "last_name" => "Wienert",
        "image" => "http://graph.facebook.com/100001844680649/picture?type=square",
        "urls" => { "Facebook" => "https://www.facebook.com/stwienert" },
        "location" => "Dresden, Germany",
        "verified" => true
      },
      "credentials" => {
        "token" => "asdasd",
        "expires_at" => 1_429_197_793,
        "expires" => true
      }
    )
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
    get :omniauth, params: { provider: :facebook }, session: {}
    expect(response).to be_redirect
    expect(AccountConnection.count).to eql 1
    expect(AccountConnection.first.user).to be_present

    get :omniauth, params: { provider: :facebook }, session: {}

    expect(response).to be_redirect
    expect(AccountConnection.count).to eql 1
  end
end
