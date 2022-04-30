class Playlist < ApplicationRecord
  belongs_to :user
  has_many :playlist_song
  has_many :songs, through: :playlist_song
end
