HnChallenge::Application.routes.draw do
  get 'about' => 'pages#about'
  resources :challenges do
    resources :participations do
      resources :activity_logs
    end
  end
  namespace :admin do
    resources :users
  end

  devise_for :users, :controllers => { :registrations => "registrations" }
  root to: 'pages#index'
end
