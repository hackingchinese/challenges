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

  get 'resources' => 'resources/stories#index'
  namespace :resources do
    resources :stories do
      member do
        post :toggle_like
      end
    end
  end

  get 'mail_preference' => 'mail_preferences#edit'
  post 'mail_preference' => 'mail_preferences#update'

  devise_for :users, :controllers => { :registrations => "registrations" }
  get '/auth/:provider/callback', to: 'account_connections#omniauth'
  root to: 'pages#index'
end
