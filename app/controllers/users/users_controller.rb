class Users::UsersController < ApplicationController
  before_action :set_users_user, only: [:show, :edit, :update, :destroy]

  # GET /users/users
  # GET /users/users.json
  def index
    @users_users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users_users }
    end
  end

  # GET /users/users/1
  # GET /users/users/1.json
  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @users_user }
    end
  end

  # GET /users/users/new
  def new
    @users_user = User.new
  end

  # GET /users/users/1/edit
  def edit
  end

  # POST /users/users
  # POST /users/users.json
  def create
    @users_user = User.new(user_params)

    respond_to do |format|
      if @users_user.save
        format.html { redirect_to @users_user, notice: 'User was successfully created.' }
        format.json { render json: @users_user, status: :created }
      else
        format.html { render action: 'new' }
        format.json { render json: @users_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/users/1
  # PATCH/PUT /users/users/1.json
  def update
    respond_to do |format|
      if @users_user.update(user_params)
        format.html { redirect_to @users_user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @users_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/users/1
  # DELETE /users/users/1.json
  def destroy
    @users_user.destroy
    respond_to do |format|
      format.html { redirect_to users_users_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_users_user
      @users_user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params[:users_user]
    end
end
