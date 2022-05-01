Rails.application.routes.draw do
  resources :songs

  resources :users do
    resources :playlists
    get 'playlists/new', to: 'playlists#new'
    post 'playlists/create', to: 'playlists#create'
    get 'playlists/:id/add/:song_id', to: 'playlists#add'
    get 'playlists/:id/remove/:song_id', to: 'playlists#remove'
    get '/users/:user_id/playlists', to: 'users#index'
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root to: 'pages#home'

  get '/login', to: 'sessions#new'
  get '/logout', to: 'sessions#destroy'
  delete '/logout', to: 'sessions#destroy'
  post '/login', to: 'sessions#create'
  get '/search', to: 'songs#search'
  get '/users', to: 'users#index'

  get "/add_song/:user_id/:song_id", to: 'songs_users#add_song'
  get "/delete_song/:user_id/:song_id", to: 'songs_users#delete_song'
  get "/smart/:user_id", to: 'songs#smart'
  get "/smart/:user_id/:song_id", to: 'songs#add_to_session'
  get "/submit", to: 'songs#smart_recs'
  get "/hipster", to: 'songs#hipster'
  post '/hipster/genres', to: 'songs#hipster_recs'
  end
