module Admin::Sites::SitesHelper

  def identify_site
    @site = Site.where(uid: params[:site]).first

    redirect_to :admin_dashboard_index if @site.nil?
  end

end
