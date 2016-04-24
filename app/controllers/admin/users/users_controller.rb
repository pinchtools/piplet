class Admin::Users::UsersController < Admin::AdminController
  respond_to :html, :js
  
  def index
    params[:list] ||= 'active'

    @users = users_selection(params[:list]).paginate(page: params[:page])

    render locals: { users: @users, list: params[:list] }
  end
  
  private
  
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