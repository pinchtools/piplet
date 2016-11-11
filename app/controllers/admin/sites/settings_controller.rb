class Admin::Sites::SettingsController < Admin::AdminController

  include Admin::Sites::SitesHelper

  before_action :identify_site
  before_action :include_sites

  layout 'admin/sites'

  def edit
    render_edit
  end

  def update
    if @site.update_attributes(site_update_params)
      flash[:success] = t 'admin.sites.settings.notice.success.updated'
      redirect_to admin_site_settings_edit_path
    else
      render_edit
    end
  end

  private

  def render_edit
    render :edit, locals: { site: @site, sites: @sites }
  end

  def site_update_params
    params.require(:site).permit(
        :name
    )
  end
end