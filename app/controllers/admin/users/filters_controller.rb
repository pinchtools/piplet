class Admin::Users::FiltersController < Admin::AdminController
  before_action :load_filters, only: [:index]
  before_action :set_filter, only: [:destroy]
  
  def index
    
  end
  
  def create
    @filter = UserFilter.new(filter_params)
    
    @filter.blocked = true
    
    @filter.save
  end
  
  
  def destroy
    
    @filter.destroy
    
  end
  
  private
  
  def load_filters
    @all_blocked = UserFilter.all_blocked
  end
  
  def set_filter
    @filter = UserFilter.find_by_id(params[:id])
  end
  
  def filter_params
    params.require(:user_filter).permit( :ip_address, 
      :email_provider )
  end
end
