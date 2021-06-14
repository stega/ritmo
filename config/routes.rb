Rails.application.routes.draw do
  devise_for :users
  resources :programme, only: [:index]
  resources :conference_sessions
  resources :events
  resources :authors

  resources :conference, only: [:index]
  resources :social, only: [:index]
  resources :users, only: [:edit, :update, :destroy]

  get '*path' => redirect('/')
  root to: 'conference#index'
end
