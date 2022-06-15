Rails.application.routes.draw do
  root to: 'tasks#index'
  get '/login', to:'sessions#new'
  post '/login', to:'sessions#create'
  namespace :admin do
    resources :users
  end
  resources :tasks
end
