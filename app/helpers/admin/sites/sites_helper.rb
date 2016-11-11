module Admin::Sites::SitesHelper

  def identify_site
    @site = Site.where(uid: params[:site_uid]).first

    redirect_to :admin_dashboard_index if @site.nil?
  end


  def include_sites
    @sites = Site.all
  end
end