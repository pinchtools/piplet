class Admin::SettingsController < Admin::AdminController
  include SettingsHelper

  def index
    @settings = Setting.get
  end

  def update
    permitted_settings.each do |key, value|
      Setting[key] = value
    end
    flash[:info] = I18n.t('settings.index.infos.reload')
    redirect_to admin_settings_url
  end

  private

  def permitted_settings
    params.require(:settings).tap do |whitelisted|
      Setting.defaults.keys.each do |k|
        if params[:settings].has_key?(k) && params[:settings][k].to_json != Setting[k].to_json
          whitelisted[k] = params[:settings][k]
        end
      end
    end
  end
end
