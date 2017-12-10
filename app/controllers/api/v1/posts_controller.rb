class Api::V1::PostsController < ApiController
  skip_before_action :authorize_request, only: :index

  before_action :set_conversation

  def index
    posts = @conversation.post

    render_success(posts, :ok)
  end

  private

  def page_params
    params.permit(
      :title,
      :url,
      :locale
    )
  end

  def set_conversation
    @conversation = @current_site.conversations.find_by_identifier(params[:identifier])
    raise Exception, I18n.t('api.errors.conversations.not_found') if @conversation.nil?
  end
end
