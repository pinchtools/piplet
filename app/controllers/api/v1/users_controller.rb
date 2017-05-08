class Api::V1::UsersController < ApiController
  include ApplicationHelper
  skip_before_action :authorize_request, only: :create

  def create
    @user = User.create( user_create_params )

    @user.creation_ip_address = request.remote_ip

    @user.locale = detect_language

    concerned_by_filters = Users::ConcernedByFiltersService.new(@user).call

    if !concerned_by_filters && @user.save
      render json: @user, status: :created
    else
      render_error(@user, :unprocessable_entity)
    end
  end

  def update
    concerned_by_filters = Users::ConcernedByFiltersService.new(@current_user).call

    if !concerned_by_filters && @current_user.update_attributes(user_update_params)
      render json: @current_user
    else
      render_error(@current_user, :unprocessable_entity)
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

  def user_update_params
    params.permit(
      :username,
      :email,
      :password,
      :password_confirmation,
      :time_zone,
      :locale,
      :description,
      avatar_attributes: [:kind, :uri, :uri_cache]
    )
  end
end