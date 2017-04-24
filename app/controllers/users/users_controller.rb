class Users::UsersController < Users::BaseController
  include ApplicationHelper

  before_action :logged_in_user, only: [ :edit, :update, :destroy]
  before_action :use_current_user, only: [:edit, :update, :destroy]
  before_action :existing_username, only: :show
  
  before_action :prevent_only_admin_removal, only: :destroy
  
  def new
    @user = User.new
    @user.build_avatar
    
    render locals: { user: @user }
  end
  
  def create
    @user = User.new(user_create_params)
    
    @user.creation_ip_address = request.remote_ip
    
    @user.locale = detect_language
    
    if @user.save
      flash[:info] = t 'user.notice.info.account-need-activation'
      redirect_to root_url
    else
      render :new, locals: { user: @user }
    end
  end
  
  def show

    unless @user.activated?
      redirect_to root_url and return
    end
    
    render locals: { user: @user }
  end
  
  def edit
    @user.build_avatar if @user.avatar.nil?
    
    render :edit, locals: { user: @user }
  end
  
  def update
    if @user.update_attributes(user_update_params)
      flash[:success] = t 'user.notice.success.updated'
      redirect_to users_edit_path
    else
      render :edit, locals: { user: @user }
    end
  end
  
  def destroy
    log_out
    @user.destroy
    
    flash[:success] = t 'user.notice.success.destroyed'
      
    redirect_to root_path
  end
  
  def check_username
    
    user = User.new(username: params[:username])
      
    if !user.valid? && user.errors.key?(:username)
      return render json: {message: user.errors[:username].first}, :status => :bad_request
    end
    
    head :ok
  end
  
  private
  
  def existing_username
    @user = User.find_by_username_lower(params[:username])
    redirect_to(root_url) unless @user
  end
  
  def prevent_only_admin_removal
    if @user.admin? && !User.admins.many?
      flash[:danger] = t('user.notice.danger.only-admin-removal')
      redirect_to :root
    end
  end
  
  def user_create_params
    params.require(:user).permit(
      :username, 
      :email,
      :password, 
      :password_confirmation,
      :time_zone,
      :description
      )
  end
  
  def user_update_params
    params.require(:user).permit(
      :username,
      :email,
      :password, 
      :password_confirmation,
      :time_zone,
      :locale,
      :description,
      avatar_attributes: [:kind, :uri, :uri_cache]
      )
  end
  
end