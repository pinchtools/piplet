module Api::ResponseHelper
  def render_error(resource, key_code)
    api_code = api_codes(key_code)

    serializer = ActiveModel::Serializer::ErrorSerializer.new(resource)
    adapter = ActiveModelSerializers::Adapter.create(serializer)
    json = adapter.as_json.merge({meta: {code: api_code[:response_code]}})

    render json: json, status: api_code[:http_code]
  end

  def render_success(resource, key_code, **instance_options)
    api_code = api_codes(key_code)
    render json: resource, status: api_code[:http_code], meta: {code: api_code[:response_code]}, **instance_options
  end

  def invalid_token_response
    user = User.new.tap{|u| u.errors.add(:base, I18n.t('user.notice.danger.invalid-token'))}
    render_error(user, :invalid_token)
  end

  def expired_token_response
    user = User.new.tap{|u| u.errors.add(:base, I18n.t('user.notice.danger.expired-token'))}
    render_error(user, :expired_token)
  end

  def unprocessable_entity_response exception
    user = User.new.tap{|u| u.errors.add(:base, exception.message)}
    render_error(user, :unprocessable_entity)
  end
end
