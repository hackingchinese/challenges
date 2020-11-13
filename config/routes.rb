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
    resources :users do
      member do
        post :block
        delete :unblock
      end
    end
    resources :quality_tables
    namespace :resources do
      resources :tags do
        collection do
          post :resort
        end
      end
    end
  end

  namespace :resources do
    match 'search' => 'search#show', via: [:get, :post], as: :search
    resources :stories do
      member do
        post :toggle_like
      end
      post 'fetch_url' => 'utilities#fetch_url', on: :collection
      resources :comments
    end
  end
  get 'u/:id' => 'users#show', as: :user
  get 'u/:id/liked' => 'users#liked', as: :user_likes
  get 'u/:id/submissions' => 'users#submissions', as: :user_submissions
  get 'resources/:level/:topic/:type/:extra' => 'resources/stories#index'
  get 'resources/:level/:topic/:type' => 'resources/stories#index'
  get 'resources/:level/:topic' => 'resources/stories#index'
  get 'resources/:level' => 'resources/stories#index'
  get 'resources' => 'resources/stories#index'

  # /s/p2akyy/decipher_chinese_level-adjusted_reading_practice
  # /s/p2akyy/decipher_chinese_level-adjusted_reading_practice/comments/e95ntq
  get 's/:short_id(/:stuff(/comments/:more_stuff))' => 'resources/migration#story_redirect'

  # /t/Intermediate
  # /t/Intermediate/Listening
  get 't/:tag1(/:tag2(/:tag3(/:tag4)))' => 'resources/migration#tag_redirect'
  get 'newest/:username' => 'resources/migration#user_page'
  get 'newest' => redirect('/resources')

  get 'mail_preference' => 'mail_preferences#edit'
  post 'mail_preference' => 'mail_preferences#update'

  resource :gdpr_consent, only: [:new, :create]

  devise_for :users, controllers: { registrations: "registrations" }
  get 'users' => redirect('users/sign_up')
  get '/auth/:provider/callback', to: 'account_connections#omniauth'
  root to: 'pages#index'
end
