json.extract! song, :id, :name, :artist, :spotify_id, :popularity, :image, :created_at, :updated_at
json.url song_url(song, format: :json)
