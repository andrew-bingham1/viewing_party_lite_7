# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
  # Defines the root path route ("/")
  root 'welcome#index'

  get '/dashboard', to: 'users#show', as: 'dashboard'
  get '/discover', to: 'users/discover#index', as: 'discover'
  get '/movies', to: 'users/movies#index', as: 'movies'

  resources :users, only: [] do
  # resources :users, only: [:show] do
    # get 'discover', to: 'users/discover#index', as: 'discover'
    # get 'movies', to: 'users/movies#index', as: 'movies'
    get 'movies/:id', to: 'users/movies#show' , as: 'movie'
    get 'movies/:id/viewing_party/new', to: 'users/viewing_party#new', as: 'new_viewing_party'
    post 'movies/:id/viewing_party/new', to: 'users/viewing_party#create', as: 'viewing_party'
  end

  get '/register', to: 'users#new', as: 'register'
  post '/register', to: 'users#create'

  get '/login', to: 'users#login_form'
  post '/login', to: 'users#login_user'
  get '/logout', to: 'users#logout'
end
