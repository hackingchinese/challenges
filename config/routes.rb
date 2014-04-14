HnChallenge::Application.routes.draw do
  get 'pages/index'
  resources :challenges do
    resources :participations do
      resources :activity_logs
    end
  end

  devise_for :users
  root to: 'pages#index'
end
