class Playlist < ApplicationRecord
  belongs_to :users
  has_many :playlist_song
  has_many :songs, through: :playlist_song
end
