class Api::V1::OauthProvidersController < ApiController
  skip_before_action :authorize_request, only: [:index]
  include SettingsHelper

  def index
    conf = Setting['global.auth']
    providers = []

    if conf.present?
      conf.each do |k,v|
        providers.push(OauthProvider.new.tap{|o| o.id = k}) if v[:enable] == '1'
      end
    end

    # providers.push(OauthProvider.new.tap{|o| o.id =  'rerere'})

    # ActiveModel::Serializer.new( OauthProvider.new('fr'))
    # ActiveModelSerializers::Adapter.create(ser)
    #
    # Setting['']
    #
    # OauthProvider.new(id: )
    # render_success(providers, :ok)
    # serializer = ActiveModel::Serializer::ArraySerializer.new(attachments, each_serializer:AttachmentSerializer)
    # render json: ActiveModel::Serializer::Adapter::JsonApi.new(serializer).as_json
    render json: providers
  end
end
