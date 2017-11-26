class Api::V1::ConversationsController < ApiController
  skip_before_action :authorize_request, only: :show

  def show
    @conversation = @current_site.conversations.find_or_initialize_by(identifier: params[:identifier])
    if @conversation.new_record? && !@conversation.update_attributes(conversation_params)
      render_error(@conversation, :unprocessable_entity) and return
    end

    page = @conversation.pages.find_or_initialize_by(url: params[:url])

    if @conversation.new_record? && !page.update_attributes(page_params)
      render_error(@conversation, :unprocessable_entity) and return
    end

    #render conversation's posts
    head :ok
  end

  private

  def conversation_params
    params.permit(
      :title
    )
  end

  def page_params
    params.permit(
      :title,
      :url,
      :locale
    )
  end
end
