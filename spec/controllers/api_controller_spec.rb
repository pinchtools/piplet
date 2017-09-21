require 'rails_helper'

RSpec.describe ApiController, type: :controller do

  shared_examples 'invalid tokens' do
    it 'raises an invalid token error' do
      expect { subject.instance_eval { authorize_request } }.to raise_error ApiController::InvalidToken
    end
  end

  describe '#authorize_request' do
    context 'no authorization header sent' do
      include_examples 'invalid tokens'
    end

    context 'invalid authorization header' do
      let(:token) { 'badtoken' }
      before do
        request.headers['Authorization'] = token
      end

      it 'raises a decoding error' do
        expect { subject.instance_eval { authorize_request } }.to raise_error JWT::DecodeError
      end
    end

    context 'token is valid' do
      let(:user) { create(:user) }
      let(:options) { {user: user.id, exp: 1.day.after.to_i, iat: 5.minutes.ago.to_i} }
      let(:token) { JsonWebToken.encode(options) }

      it 'returns the user' do
        request.headers['Authorization'] = token
        expect(subject.instance_eval { authorize_request }).to eq(user)
      end

      context 'but user is not defined' do
        before do
          options.delete(:user)
          request.headers['Authorization'] = token
        end

        include_examples 'invalid tokens'
      end

      context 'but no expiration date is set' do
        before do
          options.delete(:exp)
          request.headers['Authorization'] = token
        end

        include_examples 'invalid tokens'
      end

      context 'but no issued date is set' do
        before do
          options.delete(:iat)
          request.headers['Authorization'] = token
        end

        include_examples 'invalid tokens'
      end

      context 'but token expired' do
        before do
          options[:exp] = 1.day.ago.to_i
          request.headers['Authorization'] = token
        end

        it 'raises an expiration error' do
          expect { subject.instance_eval { authorize_request } }.to raise_error JWT::ExpiredSignature
        end
      end

      context 'but user does not exists' do
        before do
          options[:user] = user.id + 1
          request.headers['Authorization'] = token
        end

        it 'raises a record not found error' do
          expect { subject.instance_eval { authorize_request } }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end
  end
end
