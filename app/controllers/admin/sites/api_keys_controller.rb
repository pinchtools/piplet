class Admin::Sites::ApiKeysController < Admin::AdminController
  include Admin::Sites::SitesHelper

  before_action :identify_site
  before_action :include_sites
  before_action :set_api_key, only: [:destroy]

  layout 'admin/sites'

  def index
    render locals: { site: @site, sites: @sites }
  end

  def create
    @api_key = @site.api_keys.create(api_key_params)
  end

  def destroy
    @api_key.destroy
  end

  private

  def set_api_key
    @api_key = @site.api_keys.find_by_id(params[:id])
  end

  def api_key_params
    params.require(:api_key).permit( :label )
  end
end
