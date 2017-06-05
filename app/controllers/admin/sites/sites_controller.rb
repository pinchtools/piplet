class Admin::Sites::SitesController < Admin::AdminController

  include Admin::Sites::SitesHelper

  before_action :identify_site, except: [ :index, :new, :create ]
  before_action :include_sites, only: [ :show, :edit, :update ]

  layout 'admin/sites'

  def index
    redirect_to admin_site_path(Site.first.uid)
  end

  def show
    render locals: { sites: @sites }
  end

  def new

  end

  def create
    @site = Site.create(create_params)

    flash.now[:success] = t 'admin.sites.sites.notice.success.created' if @site.errors.empty?

    render locals: { site: @site }
  end

  def edit
    render_edit
  end

  def update
    if @site.update_attributes(update_params)
      flash[:success] = t 'admin.sites.sites.notice.success.updated'
      redirect_to :edit_admin_site
    else
      render_edit
    end
  end

  private

  def render_edit
    render :edit, locals: { site: @site, sites: @sites }
  end


  def create_params
    params.require(:site).permit(
        :name
    )
  end

  def update_params
    params.require(:site).permit(
        :name
    )
  end

end
