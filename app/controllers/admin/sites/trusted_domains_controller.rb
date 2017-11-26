class Admin::Sites::TrustedDomainsController < Admin::AdminController
  include Admin::Sites::SitesHelper

  before_action :identify_site
  before_action :include_sites
  before_action :set_trusted_domain, only: [:destroy]

  layout 'admin/sites'

  def index
    render locals: { site: @site, sites: @sites }
  end

  def create
    @trusted_domain = @site.trusted_domains.create(trusted_domain_params)
  end

  def destroy
    @trusted_domain.destroy
  end

  private

  def set_trusted_domain
    @trusted_domain = @site.trusted_domains.find_by_id(params[:id])
  end

  def trusted_domain_params
    params.require(:trusted_domain).permit( :domain )
  end
end
