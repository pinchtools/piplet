require 'rails_helper'

RSpec.describe Api::V1::ConversationsController, type: :controller do
  let(:user) { create(:user) }
  describe '#show' do
    #test api key/api secret or api key/domain
    # test request, required params, url on trusted domain
    # test response, presence of posts...
    # user trusted should access to all posts
    # non-authenticated, new users, blocked one should only see public posts (by trusted users)
    params = {
      identifier: 'whatever1',
      title: 'My Title',
      url: '/my-url'
    }
    include_examples 'site authentication', :get, :show, request_options: { params: params }

    context 'site authentication is valid' do
      include_context 'valid site authentication', define_site: true
      include_examples 'missing required params must result in response error',
                       :get,
                       :show,
                       request_options: { params: params.slice(:identifier) },
                       required_params: params.except(:identifier)

      context 'new conversation' do
        let(:http_request) { get :show, params: params }

        it { expect { http_request }.to change { Conversation.count }.by(1) }
        it { expect { http_request }.to change { Page.count }.by(1) }
        it 'return a successful response' do
          http_request
          expect(response).to have_http_status(:success)
        end

        describe 'response analysis' do
          before { http_request }
          [['identifier', String], ['title', String]].each do |attribute|
            include_examples 'object response contains', attribute.first, kind: attribute.last
          end
        end
      end

      context 'conversation already exists' do
        let!(:conversation) { create(:conversation, site: site, identifier: params[:identifier]) }
        let(:http_request) { get :show, params: params }

        it { expect { http_request }.not_to change { Conversation.count } }

        context 'the page exists' do
          let!(:page) { create(:page, url: params[:url], title: params[:title] + 'rr', conversation: conversation) }

          it { expect { http_request }.not_to change { Page.count } }

          describe 'the title changed' do
            it { expect { http_request }.to change { page.reload.title }.to( params[:title] ) }
          end
        end

        context 'it is a new page' do
          it { expect { http_request }.to change { Page.count }.by(1) }
        end
      end
    end
  end
end
