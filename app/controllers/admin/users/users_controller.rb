class Admin::Users::UsersController < Admin::AdminController
  include Admin::Users::UsersHelper

  before_action :identify_user, except: [:index, :search]

  before_action :prevent_only_admin_removal, only: :destroy

  before_action :load_settings, only: [ :new, :create, :edit, :update ]

  respond_to :html, :js

  def index
    params[:list] ||= 'active'

    @users = users_selection(params[:list]).paginate(page: params[:page])

    render locals: { users: @users, list: params[:list] }
  end


  def search
    params[:search] ||= ""

    min_characters = 3
    max_characters = 50

    unless (min_characters..max_characters).include?(params[:search].length)
      flash.now[:warning] = t('admin.users.users.search.notice.length-must-be-in-interval',
        :min => min_characters,
        :max => max_characters)

      @users = User.none.paginate(page: params[:page])
    else
      @users = User.search( params[:search] ).paginate(page: params[:page])
    end

    render :index, locals: { users: @users, list: nil, search: params[:search] }
  end


  def show
    redirect_to admin_users_dashboard_index_path(params[:username])
  end


  def edit
    @user.build_avatar if @user.avatar.nil?

    render :edit, locals: { user: @user }
  end


  def update
    if @user.active? && @user.update_attributes(user_update_params)
      flash[:success] = t 'user.notice.success.updated'
      redirect_to edit_admin_users_user_path
    else
      render :edit, locals: { user: @user }
    end
  end

  def block
    options = {}

    options[:blocked_note] = params['user']['blocked_note'] if params['user'].present?

    if @current_user.block_user(@user, options)
      flash[:success] = t 'user.notice.success.block'
    else
      flash[:danger] = t 'user.notice.danger.block'
    end

    redirect_to edit_admin_users_user_path
  end

  def revert_block
    if @current_user.unblock_user(@user)
      flash[:success] = t 'user.notice.success.revert-block'
    else
      flash[:danger] = t 'user.notice.danger.revert-block'
    end

    redirect_to edit_admin_users_user_path
  end

  def suspect
    options = {}

    options[:suspected_note] = params['user']['suspected_note'] if params['user'].present?


    if @current_user.suspect_user(@user, options)
      flash[:success] = t 'user.notice.success.suspect'
    else
      flash[:danger] = t 'user.notice.danger.suspect'
    end

    redirect_to edit_admin_users_user_path
  end

  def revert_suspect
    if @current_user.trust_user(@user)
      flash[:success] = t 'user.notice.success.revert-suspect'
    else
      flash[:danger] = t 'user.notice.danger.revert-suspect'
    end

    redirect_to edit_admin_users_user_path
  end

  def revert_removal
    if @user.present? && @user.deactivated?
      @user.revert_removal
      flash[:success] = t 'user.notice.success.removal-reverted'
    else
      flash[:warning] = t 'user.notice.warning.removal-revert-failed'
    end

    redirect_to edit_admin_users_user_path
  end

  def destroy
    @user.destroy

    flash[:success] = t 'user.notice.success.destroyed'

    redirect_to :admin_users_users
  end


  private


  def prevent_only_admin_removal
    if @user.admin? && !User.admins.many?
      flash[:danger] = t('user.notice.danger.only-admin-removal')
      redirect_to :admin_users_users
    end
  end

  def find_user
    @user = User.find(params[:id])
  end

  def load_settings
    @removal_delay = User.removal_delay_duration
  end

  def users_selection(kind)
    case kind
      when 'new' then User.newest
      when 'staff' then User.staff
      when 'blocked' then User.all_blocked
      when 'suspected' then User.suspects
      when 'deactivated' then User.all_deactivated
      when 'to_be_deleted' then User.all_to_be_deleted
      else User.all_valid.where(suspected: false)
    end
  end

  def user_update_params
    params.require(:user).permit(
      :username,
      :email,
      :password,
      :password_confirmation,
      :locale,
      :description,
      avatar_attributes: [:kind, :uri, :uri_cache]
      )
  end

end
