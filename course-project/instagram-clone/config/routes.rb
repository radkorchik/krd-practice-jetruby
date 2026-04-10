Rails.application.routes.draw do
  devise_for :users
  resources :posts do
    resources :comments, only: [:create, :destroy]
    post "like", to: "likes#like", as: :like
    post "dislike", to: "likes#dislike", as: :dislike
  end
  resources :users, only: [:index, :show]
  resources :follows, only: [:create, :destroy]
  get "feed" => "feeds#show", as: :feed

  get "up" => "rails/health#show", as: :rails_health_check
  root "feeds#show"
end
