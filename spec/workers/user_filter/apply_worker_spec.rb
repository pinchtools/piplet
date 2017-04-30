require 'rails_helper'
RSpec.describe UserFilter::ApplyWorker, type: :worker do
  subject { described_class.new }

  let(:queue) {'critical'}
  let(:filter) { create(:user_filter_blocked_email) }

  it 'adds a job in critical queue' do
    expect {
      described_class.perform_async
    }.to change(described_class.jobs, :size).by(1)

    expect(described_class.jobs.first).to include('queue' => queue)
  end

  context 'prevents perform_async calls' do
    before do
      allow(described_class).to receive(:perform_async)
    end

    shared_examples 'user filters relation' do
      it 'adds a relation between filter and user' do
        expect(user.filters).to be_empty
        subject.perform(filter.id)
        expect(user.filters).to eq([filter])
      end
    end

    context 'having a user concerned by email filter' do
      let(:email) { "aaa@#{filter.email_provider}" }
      let!(:user) {create(:user, email: email)}

      include_examples 'user filters relation'
    end

    describe 'when it\'s an ip_address filter' do
      context 'with an ip v4' do
        let(:ip) { Faker::Internet.ip_v4_address }
        let(:filter) { create(:user_filter_blocked_ip, ip_address: ip) }
        let!(:user) { create(:user, creation_ip_address: ip) }

        include_examples 'user filters relation'
      end

      context 'with an ip v6' do
        let(:ip) { Faker::Internet.ip_v6_address }
        let(:filter) { create(:user_filter_blocked_ip, ip_address: ip) }
        let!(:user) { create(:user, creation_ip_address: ip) }

        include_examples 'user filters relation'
      end

      context 'with a wildcard' do
        let(:ip_wildcard) { "192.168.1.*" }
        let(:ip) { ip_wildcard.sub('*', '4') }
        let(:filter) { create(:user_filter_blocked_ip, ip_address: ip) }
        let!(:user) { create(:user, creation_ip_address: ip) }

        include_examples 'user filters relation'
      end

      context 'with an ip mask' do
        let(:ip_with_mask) { "192.168.1.0/24" }
        let(:ip) { ip_with_mask.sub('0/24', '5') }
        let(:filter) { create(:user_filter_blocked_ip, ip_address: ip) }
        let!(:user) { create(:user, creation_ip_address: ip) }

        include_examples 'user filters relation'
      end
    end
  end
end