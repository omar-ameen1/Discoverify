class PlaylistsController < ApplicationController
  before_action :get_user
  before_action :set_playlist, only: %i[ show edit update destroy ]

  # GET /playlists or /playlists.json
  def index
    puts "ASDQWADFAGFSEGF"
    redirect_to @user
  end

  # GET /playlists/1 or /playlists/1.json
  def show
  end

  # GET /playlists/new
  def new
    puts "XDSDXDXDXD"
    puts params
  end

  # GET /playlists/1/edit
  def edit
  end

  def add
    p "PARAMS#{params}"
    @song = Song.find_by(id: params[:song_id])
    puts @user.inspect
    session[:return_to] ||= request.referer
    unless @playlist.songs.include? @song
      @playlist.songs << @song
      redirect_back(fallback_location: @user)
    end
  end

  # POST /playlists or /playlists.json
  def create
    puts "ASDASDA#{params}"
    @playlist = Playlist.create(name: params[:pname], user_id: @user.id)
    redirect_to @user
  end

  # PATCH/PUT /playlists/1 or /playlists/1.json
  def update
    respond_to do |format|
      if @playlist.update(playlist_params)
        format.html { redirect_to user_playlist_path(@user), notice: "Playlist was successfully updated." }
        format.json { render :show, status: :ok, location: @playlist }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @playlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /playlists/1 or /playlists/1.json
  def destroy
    @playlist.destroy

    respond_to do |format|
      format.html { redirect_to user_playlists_path(@user), notice: "Playlist was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_playlist
      @playlist = Playlist.where(user_id: @user.id)
    end

    # Only allow a list of trusted parameters through.
    def playlist_params
      params.require(:playlists).permit(:name, :user_id)
    end

  def get_user
    @user = User.find(params[:user_id])
  end
end
