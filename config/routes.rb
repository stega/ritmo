Rails.application.routes.draw do
  resources :programme, only: [:index]
  resources :conference_sessions
  resources :events
  resources :authors

  resources :conference, only: [:index]
  resources :social, only: [:index]
  resources :users, only: [:edit, :update, :destroy]
  devise_for :users

  get '*path' => redirect('/')
  root to: 'conference#index'
end
