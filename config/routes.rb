Rails.application.routes.draw do
  
  root to: 'tasks#index'
  controller :tasks do
    resources :tasks do
      post :confirm, action: :confirm_new, on: :new
      patch :confirm_edit, on: :member
      post :import, on: :collection
    end
  end

  # TODO：リファクタリングする
  # post 'task/edit/confirm', to: 'tasks#confirm_edit'

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

end
