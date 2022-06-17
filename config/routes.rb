Rails.application.routes.draw do
  root to: 'tasks#index'

  controller :sessions do
    get '/login', to:'sessions#new'
    post '/login', to:'sessions#create'
    delete '/logout', to: 'sessions#destroy'
  end

  controller :users do
    namespace :admin do
      resources :users
    end
  end

  controller :tasks do
    resources :tasks
  end
end
