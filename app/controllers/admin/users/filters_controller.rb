class Admin::Users::FiltersController < Admin::AdminController
  before_action :load_filters, only: [:index]
  
  def index
    
  end
  
  def create
    params[:user_filter][:blocked] = (params[:list_kind] == "1")
    params[:user_filter][:trusted] = (params[:list_kind] == "2")
    
    @filter = UserFilter.new(filter_params)
    
    @filter.save
    
  end
  
  
  def destroy
    
  end
  
  private
  
  def load_filters
    @all_blocked = UserFilter.all_blocked
    @all_trusted = UserFilter.all_trusted
  end
  
  def filter_params
    params.require(:user_filter).permit( :ip_address, 
      :email_provider,
      :blocked, 
      :trusted )
  end
end
