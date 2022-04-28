class Song < ApplicationRecord
  has_many :playlist_song
  has_many :songs_user
  has_many :playlists, through: :playlist_song
  has_many :users, through: :songs_user
end
