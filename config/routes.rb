Rails.application.routes.draw do
  resources :songs
  resources :users
  resources :playlists
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root to: 'pages#home'

  get '/songtest', to: 'songs#search_genre'
  get '/login', to: 'sessions#new'
  get '/logout', to: 'sessions#destroy'
  delete '/logout', to: 'sessions#destroy'
  post '/login', to: 'sessions#create'
  get '/search', to: 'songs#search'

  get "/add_song/:user_id/:song_id", to: 'songs_users#add_song'
  get "/smart/:user_id", to: 'songs#smart'
  get "/smart/:user_id/:song_id", to: 'songs#add_to_session'
end
