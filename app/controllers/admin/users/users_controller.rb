class Admin::Users::UsersController < Admin::AdminController
  before_action :find_user, only: :destroy
  before_action :is_regular_user, only: :destroy

  
  respond_to :html, :js
  
  def index
    params[:list] ||= 'active'

    @users = users_selection(params[:list]).paginate(page: params[:page])

    render locals: { users: UsersDecorator.new(@users), list: params[:list] }
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

    render :index, locals: { users: UserDecorator.new(@users), list: nil, search: params[:search] }
  end
  
  def destroy
      @user.destroy
      
      flash[:success] = t 'user.notice.success.destroyed'
      
      redirect_to :admin_users_users
  end
  
  private
  
  def find_user
    @user = User.find(params[:id])
  end
  
  def is_regular_user
    redirect_to :admin_users_users unless @user.regular?
  end
  
  def users_selection(kind)
    case kind
      when 'new' then User.newest
      when 'staff' then User.staff
      when 'blocked' then User.all_blocked
      when 'suspected' then User.suspects
      else User.actives
    end
  end
  
end