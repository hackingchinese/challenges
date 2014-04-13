HnChallenge::Application.routes.draw do
  get 'pages/index'

  devise_for :users
end
