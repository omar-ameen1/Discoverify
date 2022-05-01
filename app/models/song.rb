class Song < ApplicationRecord
  has_many :songs_user
  has_many :playlist_song
  has_many :users, through: :songs_user
  has_many :playlists, through: :playlist_song

  @total_id = 0
  class << self
    attr_accessor :total_id
  end

  def self.new_from_spotify_track(spotify_track)
    Song.new(
      spotify_id: spotify_track.id,
      name: spotify_track.name,
      image: spotify_track.album.images[0]["url"],
      artist: spotify_track.artists[0].name,
      popularity: get_popularity(spotify_track),
      preview: spotify_track.preview_url
    )
  end

  def self.get_popularity(spotify_track)
    track = RSpotify::Track.find(spotify_track.id)
    track.popularity
  end

  def self.create_from_spotify_track(spotify_track)
    track = self.new_from_spotify_track(spotify_track)
    track.save
    track
  end
end
