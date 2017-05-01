class Api::V1::TokensController < ApiController

  def create
    user = User.find_by(email: params[:email].downcase) if params[:email]

    if user && !user.blocked? && user.authenticate(params[:password])
      user.errors.add(:base, I18n.t('user.notice.warning.account-not-activated')) unless user.activated?
    else
      user ||= User.new
      user.errors.add(:base, I18n.t('user.notice.danger.invalid-login'))
    end

    if user.errors.any?
      render_error(user, :unprocessable_entity)
    else
      render json: user, status: :created
    end
  end
end
