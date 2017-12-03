class Api::V1::ConversationsController < ApiController
  skip_before_action :authorize_request, only: :show

  def show
    @conversation = @current_site.conversations.find_or_create_by(identifier: params[:identifier])
    if @conversation.new_record?
      render_error(@conversation, :unprocessable_entity) and return
    end

    page = @conversation.pages.find_or_initialize_by(url: params[:url])

    if !page.update_attributes(page_params)
      render_error(@conversation, :unprocessable_entity) and return
    end

    render_success(@conversation, :ok)
  end

  private

  def page_params
    params.permit(
      :title,
      :url,
      :locale
    )
  end
end
