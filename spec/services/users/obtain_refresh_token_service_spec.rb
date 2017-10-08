require 'rails_helper'

RSpec.describe Users::ObtainRefreshTokenService do
  subject {described_class.new(user, client_platform)}
  let(:user) {create(:user)}
  let(:client_platform) {'stateless'}

  shared_examples 'new token creation' do
    it 'creates a new refresh token' do
      expect{ subject.call }.to change(RefreshToken, :count).by(1)
    end

    it 'returns a refresh token' do
      expect(subject.call).to be_a(RefreshToken)
    end
  end

  context 'user has no refresh token for this platform' do
    include_examples 'new token creation'
  end

  context 'there\'s already an existing refresh token' do
    let(:blocked_at) { nil }
    let!(:refresh_token) { create(:refresh_token, user: user, blocked_at: blocked_at) }

    context 'and it is valid' do
      it 'returns the valid refresh token' do
        expect(subject.call.token).to eq(refresh_token.token)
      end
    end

    context 'but it\'blocked' do
      let(:blocked_at) { 1.day.ago }
      include_examples 'new token creation'
    end
  end
end
