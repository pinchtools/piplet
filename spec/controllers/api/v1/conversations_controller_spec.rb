require 'rails_helper'

RSpec.describe Api::V1::ConversationsController, type: :controller do
  let(:user) { create(:user) }
  describe '#show' do
    #test api key/api secret or api key/domain
    # test request, required params, url on trusted domain
    # test response, presence of posts...
    # user trusted should access to all posts
    # non-authenticated, new users, blocked one should only see public posts (by trusted users)
    context 'new conversation' do
      params = {
        identifier: 'whatever1',
        title: 'My Title',
        url: '/my-url'
      }
      include_examples 'site authentication', :get, :show, request_options: { params: params }
      include_examples 'missing required params must result in response error',
                       :get,
                       :show,
                       request_options: { params: params.slice(:identifier) },
                       required_params: params.except(:identifier)
    end
  end
end
