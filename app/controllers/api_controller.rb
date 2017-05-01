class ApiController < ActionController::API

  #around_action :set_time_zone, if: :current_user

  private

  def render_error(resource, status)
    render json: resource, status: status,
           serializer: ActiveModel::Serializer::ErrorSerializer
  end

  # def set_time_zone(&block)
  #   Time.use_zone(current_user.time_zone, &block)
  # end
  
end
