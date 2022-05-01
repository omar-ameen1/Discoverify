class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :authenticate_user, except: %i[ new create ]
  before_action :same_user, only: %i[ edit destroy ]

  # GET /users or /users.json
  def index
    redirect_to "/users/#{current_user.id}"
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)
    @user.password = user_params[:password_hash]
    @user.save

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    @user.assign_attributes(:full_name => params[:user][:full_name], :username => params[:user][:username],
                            :password_hash => params[:user][:password_hash])
    @user.password = params[:user][:password_hash]
    @user.save!

    respond_to do |format|
      if @user.save!
        format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { redirect_to login_path }
        format.json { render :show }
      end
    end

  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      reset_session
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:full_name, :username, :password_hash, :spotifyuid, :humanizer_answer, :humanizer_question_id)
    end
end
