Whetstone::Application.routes.draw do
  root to: 'dashboards#show'
  get '/auth/:provider/callback', to: 'oauth_callbacks#show'
  get '/auth/failure', to: 'dashboards#show'

  resource :clone_help_page, only: [:show]

  resources :exercises, only: :show do
    resource :clone, only: [:create, :show]
    resources :solutions, only: [:new, :create] do
      resources :revisions, only: [:show]
    end
    resource :username, only: :update
  end

  get(
    'exercises/:exercise_id/solutions/:solution_id',
    to: 'revisions#show',
    as: :exercise_solution
  )

  resources :solutions, only: [] do
    resources :comments, only: [:new, :create]
  end

  namespace :admin do
    root to: 'dashboards#show'
    resources :exercises, only: [:index, :new, :create, :edit, :update]
    resources :solutions, only: [:index]
  end

  namespace :api do
    # Must match the URL from hooks/post-receive
    post 'pushes/:user_id/:exercise_id', to: 'pushes#create', as: :pushes

    resources :solutions, only: [:index]
  end

  namespace :gitolite do
    resources :public_keys, only: [:new, :create]
  end
end
