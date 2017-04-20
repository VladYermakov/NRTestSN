Rails.application.routes.draw do
  scope :api do
    devise_for :users
  end

  namespace :api do
    resources :articles,      only: [:index, :show, :create, :update, :destroy] do
      resources :comments,    only: [:index, :create]
      resource :attachment,   only: [:update]
    end
    resources :comments,      only: [:index, :show, :update, :destroy]
    resources :attachments,   only: [:new, :create]
    resources :relationships, only: [:create, :destroy]
    resources :users,         only: [] do
      member do
        get :following
        get :followers
        get '/articles' => 'articles#user_articles'
        get :relationships_info
      end
    end
  end
  get '/api/feed' => 'api/users#feed', as: 'feed_api_user'
  get '/files/:id' => 'api/attachments#show', as: 'file_attachment'

  root to: 'application#angular'
  get '*path' => 'application#angular'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
