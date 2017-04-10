Rails.application.routes.draw do
  scope :api do
    devise_for :users
  end

  namespace :api do
    resources :articles, only: [:index, :show, :create, :update, :destroy] do
      resources :comments, only: [:index, :create, :update, :destroy]
      resource :attachment, only: [:show, :update]
    end
  end

  root to: 'application#angular'
  get '*path' => 'application#angular'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
