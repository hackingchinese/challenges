HnChallenge::Application.routes.draw do
  resources :challenges do
    resources :participations do
      resources :activity_logs
    end
  end
  namespace :admin do
    resources :users
    resources :quality_tables
  end

  devise_for :users, :controllers => { :registrations => "registrations" }
  root to: 'pages#index'
end
