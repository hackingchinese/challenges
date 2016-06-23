HnChallenge::Application.routes.draw do
  resources :challenges do
    resources :participations do
      resources :activity_logs do
        member do
          post :toggle_like
        end
        resources :comments, only: [:new, :create]
      end
    end
  end
  namespace :admin do
    resources :users
    resources :quality_tables
  end

  namespace :resources do
    resources :stories do
      member do
        post :toggle_like
      end
      post 'fetch_url' => 'utilities#fetch_url', on: :collection
      resources :comments
    end
  end
  get 'resources/:tier_0(/:tier_1(/:tier_2(/:tier_3)))' => 'resources/stories#index'
  get 'resources' => 'resources/stories#index'

  get 'mail_preference' => 'mail_preferences#edit'
  post 'mail_preference' => 'mail_preferences#update'

  devise_for :users, :controllers => { :registrations => "registrations" }
  get '/auth/:provider/callback', to: 'account_connections#omniauth'
  root to: 'pages#index'
end
