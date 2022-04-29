class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(username: params[:username])
    if @user
      if @user.password == params[:password_hash]
        session[:user_id] = @user.id
        redirect_to root_path
      else
        render :new
      end
    else
      render :new
    end
  end

  def destroy
    reset_session
    redirect_to '/login'
  end
end