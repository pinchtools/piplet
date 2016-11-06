class Admin::Sites::SitesController < Admin::AdminController

  include Admin::Sites::SitesHelper

  before_action :identify_site, except: [ :index ]
  before_action :include_sites, only: [ :show ]

  def index
    redirect_to admin_site_path(Site.first.uid)
  end

  def show
    render locals: { sites: @sites }
  end

  def new

  end

  def create

  end

  def edit

  end

  def update

  end

end
