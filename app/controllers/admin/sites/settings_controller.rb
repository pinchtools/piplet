class Admin::Sites::SettingsController < Admin::AdminController

  include Admin::Sites::SitesHelper

  before_action :identify_site
  before_action :include_sites, only: [ :edit ]

  def edit
    render locals: { sites: @sites }
  end

  def update

  end
end