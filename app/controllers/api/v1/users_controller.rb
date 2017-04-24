class Api::V1::UsersController < ApiController
  include ApplicationHelper

  def create
    @user = User.create( user_create_params )

    @user.creation_ip_address = request.remote_ip

    @user.locale = detect_language

    if @user.save
      render json: @user, status: :created
    else
      render_error(@user, :unprocessable_entity)
    end
  end

  private

  def user_create_params
    params.permit(
        :username,
        :email,
        :password,
        :password_confirmation,
        :time_zone
    )
  end

end
