class SongsController < ApplicationController
  before_action :set_song, only: %i[ show edit update destroy ]
  before_action :authenticate_user

  # GET /songs or /songs.json
  def index
    @songs = Song.all
  end

  def top_10
    s_tracks = RSpotify::Playlist.find("1276640268","2kpoUUJ5a4Cw3feTkFJhZ2").tracks
    @tracks = s_tracks.map do |s_track|
      Song.new_from_spotify_track(s_track)
    end
    render json @tracks
  end

  def search_genre
    s_tracks = RSpotify::Recommendations.generate(limit: 20, seed_genres: ['hip-hop'],
                                                  max_popularity: 0, target_popularity: 0).tracks
    @tracks = s_tracks.map do |s_track|
      Song.create_from_spotify_track(s_track)
    end
    @tracks.each do |track|
      pp track[:name]
      pp track[:artist]
    end
    render json: @tracks
  end
  # GET /songs/1 or /songs/1.json
  def show
  end

  def add_to_session
    (session[:songs] ||= [])
    unless session[:songs].include? params[:song_id]
      session[:songs] << params[:song_id]
    end
    redirect_back(fallback_location: "/smart/#{current_user.id}")
  end

  def smart_recs
    if session[:songs].size > 0
      session[:stored] = session[:songs]
    end
    sarr = session[:stored].compact
    s_tracks = sarr.map do |song|
      s = Song.find_by(id: song)
      s.spotify_id
    end
    @recs = RSpotify::Recommendations.generate(limit: 4, seed_tracks: s_tracks)
    @stracks = @recs.tracks
    @tracks = @stracks.map do |t|
      if Song.all.include?(Song.find_by(spotify_id: t.id))
        Song.find_by(spotify_id: t.id)
      else
        Song.create_from_spotify_track(t)
      end
    end
    session[:songs] = []
  end

  def search
    if params[:search].empty?
      redirect_to songs_path
    else
      s_tracks = RSpotify::Track.search(params[:search])
      @tracks = s_tracks.map do |s_track|
        if Song.all.include?(Song.find_by(spotify_id: s_track.id))
          Song.find_by(spotify_id: s_track.id)
        else
          Song.create_from_spotify_track(s_track)
        end
      end
    end
  end

  def smart

  end

  def smart_search
  end

  def hipster
    if params[:genre]
      hipster_recs
    end
  end

  def hipster_recs
    @recs = RSpotify::Recommendations.generate(seed_genres: params[:genre].lines.to_a, limit: 3, max_popularity: 10, target_popularity: 0)
    @htracks = @recs.tracks
    @tracks = @htracks.map do |t|
      if Song.all.include?(Song.find_by(spotify_id: t.id))
        Song.find_by(spotify_id: t.id)
      else
        Song.create_from_spotify_track(t)
      end
    end
    render "songs/hipster_recs"
    puts @recs.inspect
    puts @tracks.inspect
  end

  # GET /songs/new
  def new
    @song = Song.new
  end

  # GET /songs/1/edit
  def edit
  end

  # POST /songs or /songs.json
  def create
    respond_to do |format|
      if @song.save
        format.html { redirect_to song_url(@song), notice: "Song was successfully created." }
        format.json { render :show, status: :created, location: @song }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /songs/1 or /songs/1.json
  def update
    respond_to do |format|
      if @song.update(song_params)
        format.html { redirect_to song_url(@song), notice: "Song was successfully updated." }
        format.json { render :show, status: :ok, location: @song }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /songs/1 or /songs/1.json
  def destroy
    @song.destroy

    respond_to do |format|
      format.html { redirect_to songs_url, notice: "Song was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_song
      @song = Song.find_by(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def song_params
      params.require(:song).permit(:name, :artist, :spotify_id, :popularity, :image, :search)
    end
  end
