class SongsUsersController < ApplicationController
  before_action :set_song
  before_action :set_user
  before_action :authenticate_user
  before_action :same_user, only: %i[ add_song delete_song ]

  def add_song
    session[:return_to] ||= request.referer
    @user.songs << @song
    redirect_to session.delete(:return_to)
  end

  def delete_song
    if @user.songs.include? @song
      @user.songs.delete(@song)
      redirect_to @user
    end
  end

  private

  def set_user
    puts params
    @user = User.find(params[:user_id])
  end

  private

  def set_song
    @song = Song.find(params[:song_id])
  end
end
