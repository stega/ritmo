Rails.application.routes.draw do
  resources :workshops
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :conference, only: [:index]
  resources :social, only: [:index]

  root to: 'conference#index'
end
